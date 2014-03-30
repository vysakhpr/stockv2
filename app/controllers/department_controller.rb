class DepartmentController < ApplicationController
	include ApplicationHelper
	include DepartmentHelper
  include AdminHelper
  include LabHelper

  before_filter :signed_in_hod, :only=>[:index,:sign_out,:transfer,:transfer_update]
  before_filter :signed_in_admin, :only=>[:create,:register]
	before_filter :sign_out_user, :only=>[:login, :sign_in]
  

  def index
    unless params[:search].blank?
      @search=Office.search do 
        fulltext params[:search] do
          query_phrase_slop 1
          minimum_match 1
        end
        with(:department_id,current_user.id)
        paginate :page=>params[:page],:per_page=>30
      end
    end


    @labs=current_user.labs
    @offices=current_user.offices.order(sort_column + ' ' + sort_direction)
    @hods=[]
    @offices.each do |t|
      unless t.labstocks.exists?
        @hods<<t
      end
      if (t.labstocks.exists?)&&(t.quantity_assigned<t.quantity)
        @hods<<t
      end
      @donor=current_user.labs
    end 
    @department_messages=current_user.messages.all
    @writeoff_messages=[]
    @request_messages=[]
    @department_messages.each do |t|
      unless t.sender==current_user_type
        if t.message_type=="writeoff"
          @writeoff_messages<<t
        elsif t.message_type=="request"
          @request_messages<<t
        end
      end 
    end
  end

  def login
  end

  def register
  	@department=Department.new
  end
  
  def create
		@department=Department.new(params[:department])
		if @department.save
      user=User.new(:username=>params[:department][:username],:role=>"HOD")
      if user.save
       flash[:success]="Added New Department Successfully"
       redirect_to root_url
      else
        raise ActiveRecord::Rollback
        flash[:error]=user.errors.full_messages.to_sentence
        redirect_to :back
      end
		else
			flash[:error]="Oops Something has gone wrong"
			redirect_to :back
		end
	end

	def sign_in
  	department=Department.find_by_username(params[:username])
  		if department && department.authenticate(params[:password])
  			session[:department_id]= department.id
  			flash[:notice]="Welcome #{department.name} Department Head"
  			redirect_to root_url
  		else
  			flash[:error]="Invalid credentials"
  			redirect_to :back
  		end
  end

  def sign_out
  	session[:department_id]=nil
  	flash[:notice]="You have Successfully logged out"	
  	redirect_to root_url
  end

  def transfer
    @donor=Labstock.find(params[:id])
    if current_user.name != @donor.lab.department.name
      flash[:error]="Invalid Url"
      redirect_to root_url
    end
    
  end

  def transfer_update
    @donor_stock=Labstock.find(params[:donor_stock_id])
    donor_id=@donor_stock.lab_id
    donor_stock=@donor_stock.office.name
    donor_voucher_no=@donor_stock.office.voucher_no
    @receiver_lab=Lab.find(params[:receiver][:id])
    @quantity=params[:quantity]
    available_quantity=@donor_stock.quantity-@donor_stock.quantity_used
    if @quantity.to_i>available_quantity
      flash[:error]="Not enough quantity available "
      redirect_to "/department/transfer/#{@donor_stock.id}"
    else  
      if @quantity.to_i >@donor_stock.quantity
        flash[:error]="Quantity Overflow"
        redirect_to "/department/transfer/#{@donor_stock.id}"
      else
        unless @quantity.nil? || @receiver_lab.nil?
          @receiver_stock=@receiver_lab.labstocks.find_by_office_id(@donor_stock.office_id)
          if @receiver_stock.nil?
            @labstock=Labstock.new(office_id:@donor_stock.office_id,quantity:@quantity,lab_id:@receiver_lab.id)
            if (@labstock.office.quantity-@labstock.office.quantity_assigned) < @labstock.quantity
              flash[:error]="Quantity over full size"
              redirect_to "/department/transfer/#{@donor_stock.id}"
            elsif !(@labstock.save)
              flash[:error]=@labstock.errors.full_messages.to_sentence
              redirect_to "/department/transfer/#{@donor_stock.id}"
            end 
          else
            @receiver_stock.quantity=@receiver_stock.quantity+@quantity.to_i
            unless @receiver_stock.save
              flash[:error]=@receiver_stock.errors.full_messages.to_sentence
              redirect_to "/department/transfer/#{@donor_stock.id}"
            end  
          end
          @donor_stock.quantity=@donor_stock.quantity-@quantity.to_i
          if @donor_stock.quantity<1
            @donor_stock.destroy
          elsif !(@donor_stock.save)
            flash[:error]=@donor_stock.errors.full_messages.to_sentence
            raise ActiveRecord::Rollback
            redirect_to "/department/transfer/#{@donor_stock.id}"
          end
          donor_message=Message.new(:department_id=>current_user.id,:lab_id=>donor_id,:message_type=>"ack",:name=>"#{@quantity} #{donor_stock},voucher number #{donor_voucher_no}, have been transferred FROM your lab by the department_head",:quantity=>0,:sender=>"Lab")
          receiver_message=Message.new(:department_id=>current_user.id,:lab_id=>@receiver_lab.id,:message_type=>"ack",:name=>"#{donor_stock},voucher number #{donor_voucher_no}, has been transferred as per your request",:quantity=>0,:sender=>"Lab")
          if donor_message.save and receiver_message.save     
            flash[:notice]="Successfully Transferred"
          else
            flash[:error]="Successfully Transferred but acknowledgements to corresponding labs not send. Please do it manually "
          end
          redirect_to root_url
        end
      end
    end
  end
end
