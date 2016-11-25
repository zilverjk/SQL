create proc SP_TRANS_DOCU_Q01
@isco_empr varchar(2),
@isti_docu varchar(3),
@isnu_docu varchar(20),
@isco_item varchar(20)

as

declare
@vnca_actu numeric(16,4),
@vnre_esta int, 
@vsco_alama_refe varchar(3)

--Verifico que el documento este ACTIVO, si esta anulado devuelve 1
select @vnre_esta = count(*) from tcdocu_clie where co_empr = @isco_empr and ti_docu = @isti_docu and nu_docu = @isnu_docu and co_esta_docu = 'ANU'

if @vnre_esta = 0
begin
--Verifico el stock en el 272
select @vnca_actu = ca_actu from tastoc_actu where co_alma = '272' and co_item = @isco_item

end
else
begin

--El documento esta anulado
select isnull(@vnca_actu,0) , @vnre_esta, @vsco_alama_refe

end