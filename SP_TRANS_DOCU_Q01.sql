CREATE PROC SP_TRANS_DOCU_Q01
@ISCO_EMPR VARCHAR(2),
@ISTI_DOCU VARCHAR(3),
@ISNU_DOCU VARCHAR(20),
@ISCO_ITEM VARCHAR(20)

AS

DECLARE
@VNCA_ACTU NUMERIC(16,4),
@VNRE_ESTA INT, 
@VSCO_ALAMA_REFE VARCHAR(3)

--VERIFICO QUE EL DOCUMENTO ESTE ACTIVO, SI ESTA ANULADO DEVUELVE 1
SELECT @VNRE_ESTA = COUNT(*) FROM TCDOCU_CLIE WHERE CO_EMPR = @ISCO_EMPR AND TI_DOCU = @ISTI_DOCU AND NU_DOCU = @ISNU_DOCU AND CO_ESTA_DOCU = 'ANU'

IF @VNRE_ESTA = 0 --SI EL DOCUMENTO ESTA ACTIVO
BEGIN
--VERIFICO EL STOCK EN EL 272
SELECT @VNCA_ACTU = CA_ACTU, @VSCO_ALAMA_REFE = CO_ALMA FROM TASTOC_ACTU WHERE CO_ALMA = '272' AND CO_ITEM = @ISCO_ITEM


IF @VNCA_ACTU <= 0
BEGIN
--VERIFICO EL STOCK EN EL 572 SI NO TIENE EN EL 272
SELECT @VNCA_ACTU = CA_ACTU, @VSCO_ALAMA_REFE = CO_ALMA FROM TASTOC_ACTU WHERE CO_ALMA = '572' AND CO_ITEM = @ISCO_ITEM
END

END

IF @VNRE_ESTA != 0 -- SI EL DOCUMENTO ESTA ANULADO
BEGIN 
SELECT @VNCA_ACTU = 0, @VSCO_ALAMA_REFE = ''
END

--DEVUELVE PARAMETROS
SELECT @VNCA_ACTU, @VNRE_ESTA, @VSCO_ALAMA_REFE