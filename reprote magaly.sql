sp_helptext SP_TMDOCU_CLIE_Q09

select*from tmclie

create table temp_prov_lcred
(co_clie varchar(20),
no_razo_soci varchar(200),
im_limi_cred numeric(18,2),
im_cred_usad numeric(18,2))

insert into temp_prov_lcred
select co_clie, case when no_razo_soci = '' then no_clie else no_razo_soci end,
 IM_LIMI_CRED, 0 from tmclie where co_empr = '02' and im_limi_cred > 0 --and co_clie = '20100154057'

select*from temp_prov_lcred

create table temp_porv_lcred_usad (co_clie varchar(20), im_cred_usad numeric(18,2))

insert into temp_porv_lcred_usad
select t1.co_clie, sum((PatIndex(T7.ST_SIGN,'S') - PatIndex(T7.ST_SIGN,'N'))*(Isnull(T1.IM_TOTA,0))) as im_cred_usad
from TMDOCC_GENE t1
JOIN TTDOCU_CNTB  T7 ON	T1.CO_TIPO_DOCU = T7.TI_DOCU
JOIN TMAUXI_EMPR T5 ON   T1.CO_EMPR = T5.CO_EMPR AND T1.CO_CLIE = T5.CO_AUXI_EMPR
join temp_prov_lcred x1 on x1.co_clie = t1.co_clie
Where T1.FE_EMIS <= '2016/11/25'                    
AND T1.IM_TOTA - T1.IM_PAGA > 0                     
AND T5.TI_AUXI_EMPR = 'C'
AND T1.CO_ESTA_DOCU != 'ANU'
group by t1.co_clie
--and t1.co_clie = '20100154057'

update temp_prov_lcred set im_cred_usad = x1.im_cred_usad
from temp_porv_lcred_usad x1
join temp_prov_lcred t1 on x1.co_clie = t1.co_clie


drop table temp_prov_lcred
drop table temp_porv_lcred_usad

union all

SELECT SUM((PATINDEX(T7.ST_SIGN,'S') - PATINDEX(T7.ST_SIGN,'N'))*(ISNULL(T1.IM_TOTA,0)))
FROM TCDOCU_CLIE T1
JOIN TTDOCU_CNTB  T7 ON	T1.TI_DOCU = T7.TI_DOCU
LEFT OUTER JOIN TTCOND_PAGO T3 ON T1.CO_EMPR = T3.CO_EMPR AND T1.CO_COND_PAGO = T3.CO_COND_PAGO 
JOIN TMAUXI_EMPR T5 ON   T1.CO_EMPR = T5.CO_EMPR AND T1.CO_CLIE = T5.CO_AUXI_EMPR 
join temp_prov_lcred x1 on x1.co_clie = t1.co_clie
WHERE T1.FE_DOCU  <= '2016/11/25'
  AND T1.IM_TOTA-T1.IM_PAGA > 0
  AND T1.CO_ESTA_DOCU != 'PAG'
  AND T5.TI_AUXI_EMPR = 'C'
  AND T3.TI_COND = 'CON'
  AND T1.CO_TIEN  IN(SELECT CO_TIEN FROM OFIVENT..TMTIEN WHERE CO_EMPR = '02' AND ST_PROY = 'S')
  and t1.co_clie = x1.co_clie
  AND T1.CO_ESTA_DOCU != 'ANU'
  AND NOT EXISTS (SELECT CO_EMPR FROM TMDOCC_GENE T2
  WHERE	T2.CO_EMPR =T1.CO_EMPR                    
  AND	T2.CO_CLIE = T1.CO_CLIE
  AND	T2.CO_TIPO_DOCU = T1.TI_DOCU
  AND	T2.NU_DOCU_CLIE = T1.NU_DOCU)
