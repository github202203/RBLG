--SQL Script for Requirement  5.3 Remove Claim_ID from Outward Fact
--Display the list of views with Claim_Id column under RS schema ( should return no records )
select 'Req5.3	Remove Claim_ID from Outward Fact' as ReqId,*, GetDate() as TestedOn from information_schema.view_column_usage
 where view_schema = 'RS'
   and table_name like '%OUTW%Claim%'
   and UPPER(column_name) like '%CLAIM%' 
 order by view_name, table_schema

--Display the list of tables having Claim_ID column ( Should not be in Dim/Fact/Control schema )
select 'Req5.3	Remove Claim_ID from Outward Fact' as ReqId,table_catalog,table_schema,table_name,column_name, GetDate() as TestedOn
  from information_schema.COLUMNS
 where UPPER(table_name) like '%OUTW%Claim%'
   and UPPER(column_name) like '%CLAIM%' 