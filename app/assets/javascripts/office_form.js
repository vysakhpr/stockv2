$('.calc').bind('keypress keydown keyup change',function(){
	var price_unit = parseFloat($('#price_unit').val());
	var quantity = parseFloat($('#quantity').val());
	var v='';
	v=price_unit*quantity;
	if(!isNaN(v)){
		$('#total_price').val(parseFloat(v).toFixed(2));
	}
});
