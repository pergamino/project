insert into evaluacion_regional_roya (anio,mes) 
select date_part('year',date_trunc('month', current_date - interval '1 month')),
       date_part('month',date_trunc('month', current_date - interval '1 month'))
       where not exists (select anio, mes from evaluacion_regional_roya where anio = date_part('year',date_trunc('month', current_date - interval '1 month')) 
       and mes = date_part('month',date_trunc('month', current_date - interval '1 month')));
insert into evaluacion_regional_roya_detalle select 
anio,
mes,
cod_periodo,
cod_catvariedad,
cod_pais,
cod_region,
incidencia_media,
case when cod_catvariedad = 3 then (
	case when cod_periodo = 3 then (
		case 
			when incidencia_media >= 0 and incidencia_media <= 3 then 10
			when incidencia_media > 3 and incidencia_media <= 5 then 9
			when incidencia_media > 5 and incidencia_media <= 10 then 8
			when incidencia_media > 10 and incidencia_media <= 20 then 11
			else 7
		end
	) else (
		case 
			when incidencia_media >= 0 and incidencia_media <= 3 then 10
			when incidencia_media > 3 and incidencia_media <= 5 then 9
			when incidencia_media > 5 and incidencia_media <= 20 then 8
			when incidencia_media > 20 and incidencia_media <= 30 then 11
			else 7
		end	
	) end
) else 12 end as cod_alerta_res,
case when cod_catvariedad = 2 then (
	case when cod_periodo = 3 then (
		case 
			when incidencia_media >= 0 and incidencia_media <= 5 then 10
			when incidencia_media > 5 and incidencia_media <= 10 then 9
			when incidencia_media > 10 and incidencia_media <= 15 then 8
			when incidencia_media > 15 and incidencia_media <= 20 then 11
			else 7
		end
	) else (
		case 
			when incidencia_media >= 0 and incidencia_media <= 5 then 10
			when incidencia_media > 5 and incidencia_media <= 15 then 9
			when incidencia_media > 15 and incidencia_media <= 20 then 8
			when incidencia_media > 20 and incidencia_media <= 30 then 11
			else 7
		end
	) end
) else 12 end as cod_alerta_med,
case when cod_catvariedad = 1 then (
	case when cod_periodo = 3 then (
		case 
			when incidencia_media >= 0 and incidencia_media <= 3 then 10
			when incidencia_media > 3 and incidencia_media <= 5 then 9
			when incidencia_media > 5 and incidencia_media <= 10 then 8
			when incidencia_media > 10 and incidencia_media <= 20 then 11
			else 7
		end
	) else (
		case 
			when incidencia_media >= 0 and incidencia_media <= 5 then 10
			when incidencia_media > 5 and incidencia_media <= 15 then 9
			when incidencia_media > 15 and incidencia_media <= 20 then 8
			when incidencia_media > 20 and incidencia_media <= 30 then 11
			else 7
		end
	) end
) else 12 end as cod_alerta_sus,
nregistros
from (select 
anio,
mes,
cod_periodo,
cod_catvariedad,
cod_pais,
cod_region,
avg(incidencia) as incidencia_media,
count(*) as nregistros
from (select
date_part('year',e.fecha_evaluacion) as anio,
date_part('month',e.fecha_evaluacion) as mes,
e.cod_periodo,
cv.cod_catvariedad,
c.paiscod_pais as cod_pais,
cod_region,
e.incidencia 
from evaluacion_roya e 
inner join categoria_variedad cv on cv.catvariedad = e.catvariedad
inner join lotes l on e.cod_lote = l.cod_lote
inner join cafetales c on l.cod_cafetal = c.cod_cafetal
inner join sat_regiones on st_within(st_geomfromtext('POINT(' || c.lon || ' ' || c.lat || ')',4326),sat_regiones.geom)
inner join region_alerta ra on sat_regiones.rrat5 = ra.nombre
where e.fecha_evaluacion >= date_trunc('month', current_date - interval '1 month')
) as t1 
group by
anio,
mes,
cod_periodo,
cod_catvariedad,
cod_pais,
cod_region) as t2;