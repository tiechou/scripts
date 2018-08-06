create external table foo
(
uid bigint, 
brand_value string
)
row format delimited fields terminated by '\001'
stored as textfile
location "/group/tbsc-dev/haowen/temp/shpsrch_bshop_brand_value_ssmerge_1011/";



INSERT OVERWRITE TABLE foo
select uid,value_data
from
(
  select t1.uid,t2.value_data
  from
     shpsrch_bshop_brand_unfold_ssmerge_1011 t1
     join sel_shpsrch__base_values t2
     on t1.brand_id = t2.value_id and t2.ds=20101019
) a
;


echo "select * from foo where uid=153702175;" | hive -u root -p root | 


set mapred.reduce.tasks=1;
add file /data/tiechou/ssmerge/mod/mod_bshop_brand/script/brand_packed.pl;
explain
INSERT OVERWRITE TABLE foo
  select transform(uid, value_data)
  using 'brand_packed.pl'
  as uid,brand_value
  from
(
select t1.uid,t2.value_data
  from
     shpsrch_bshop_brand_unfold_ssmerge_1011 t1
     join sel_shpsrch__base_values t2
     on t1.brand_id = t2.value_id and t2.ds=1 distribute by t1.uid
) a
;


$hive_cmd <<EOF
set mapred.reduce.tasks=1;
add file ${SSM_mod_bshop_brand}/script/brand_packed.pl;

INSERT OVERWRITE TABLE ${HIVETBL_shpsrch_bshop_brand_value}
select uid,brand_value
from
(
  select transform(t1.uid,t2.value_data)
  using 'brand_packed.pl'
  as uid,brand_value
  from
     ${HIVETBL_shpsrch_bshop_brand_unfold} t1
     join ${HIVETBL_shpsrch_base_values} t2
     on t1.brand_id = t2.value_id and t2.ds=${latest_partition_sel_shpsrch__base_values}
) a
;
set mapred.reduce.tasks=256;
EOF


add file /data/tiechou/ssmerge/mod/mod_bshop_brand/script/brand_packed.pl;
INSERT OVERWRITE TABLE foo
select transform(t3.uid,t3.value_data)
  using 'brand_packed.pl'
  as uid,brand_value
from(
from shpsrch_bshop_brand_unfold_ssmerge_1011 t1 join sel_shpsrch__base_values t2 on (t1.brand_id = t2.value_id and t2.ds=20101019) select t1.uid,t2.value_data distribute by t1.uid) t3;
