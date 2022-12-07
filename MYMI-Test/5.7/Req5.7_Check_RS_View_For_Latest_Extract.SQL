--Building the SQL Scripts dynamically to check all the views to make sure it's matching with the latest reconciled DATA
select 'select DISTINCT ' +  '''' + T.VIEW_NAME + '''' + ' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].' + t.VIEW_NAME + ' UNION ALL '
  from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].information_schema.view_table_usage  T
 where view_schema = 'RS'
   and table_name in (
                       'INW_GroupClass'
                      ,'INW_Loss'
                      ,'INW_LossEvent'
                      ,'INW_RISK'
                      ,'INW_OSClaim'
                      ,'INW_PaidClaim'
                      ,'INW_Premium'
                      ,'INW_WrittenPremium'
                      ,'INW_OSClaim'
                      ,'INW_PaidClaim'
                      ,'INW_Premium'
                      ,'INW_WrittenPremium'
                      ,'OUTW_GroupClass'
                      ,'OUTW_LossEvent'
                      ,'OUTW_RIContract'
                      ,'OUTW_RIContractAcc'
                      ,'OUTW_RIContractCcyLimit'
                      ,'OUTW_RIContractIns'
                      ,'OUTW_Risk'
                      ,'OUTW_OSClaim'
                      ,'OUTW_OSPremium'
                      ,'OUTW_PaidClaim'
                      ,'OUTW_PaidPremium'
                      ,'OUTW_OSClaim'
                      ,'OUTW_PaidClaim'
                      ,'OUTW_OSPremium'
                      ,'OUTW_PaidPremium'
                      )

-- Below SQL scripts were built from the above query and simply run it from MYMI-Test

SELECT '[RS].[LoadStatus]' as ViewName, Date_Of_Load, [Load_status] ,[Load_ID] FROM [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].[LoadStatus]
select DISTINCT 'INW_Control_OS_Claim' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_Control_OS_Claim UNION ALL 
select DISTINCT 'INW_Group_Class' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_Group_Class UNION ALL 
select DISTINCT 'INW_Loss' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_Loss UNION ALL 
select DISTINCT 'INW_Loss_Event' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_Loss_Event UNION ALL 
select DISTINCT 'INW_OS_Claim_Extract' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_OS_Claim_Extract UNION ALL 
select DISTINCT 'INW_Paid_Claim_Control' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_Paid_Claim_Control UNION ALL 
select DISTINCT 'INW_Paid_Claim_Extract' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_Paid_Claim_Extract UNION ALL 
select DISTINCT 'INW_Premium_Control' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_Premium_Control UNION ALL 
select DISTINCT 'INW_Premium_Extract' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_Premium_Extract UNION ALL 
select DISTINCT 'INW_Risk' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_Risk UNION ALL 
select DISTINCT 'INW_Written_Premium_Control' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_Written_Premium_Control UNION ALL 
select DISTINCT 'INW_Written_Premium_Extract' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].INW_Written_Premium_Extract UNION ALL 
select DISTINCT 'OUTW_Control_OS_Claim' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_Control_OS_Claim UNION ALL 
select DISTINCT 'OUTW_Control_OS_Premium' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_Control_OS_Premium UNION ALL 
select DISTINCT 'OUTW_Control_Paid_Claim' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_Control_Paid_Claim UNION ALL 
select DISTINCT 'OUTW_Control_Paid_Premium' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_Control_Paid_Premium UNION ALL 
select DISTINCT 'OUTW_Group_Class' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_Group_Class UNION ALL 
select DISTINCT 'OUTW_Loss_Event' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_Loss_Event UNION ALL 
select DISTINCT 'OUTW_OS_Claim_Extract' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_OS_Claim_Extract UNION ALL 
select DISTINCT 'OUTW_OS_Premium_Extract' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_OS_Premium_Extract UNION ALL 
select DISTINCT 'OUTW_Paid_Claim_Extract' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_Paid_Claim_Extract UNION ALL 
select DISTINCT 'OUTW_Paid_Premium_Extract' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_Paid_Premium_Extract UNION ALL 
select DISTINCT 'OUTW_RI_Contract' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_RI_Contract UNION ALL 
select DISTINCT 'OUTW_RI_Contract_Acc' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_RI_Contract_Acc UNION ALL 
select DISTINCT 'OUTW_RI_Contract_Ccy_Limit' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_RI_Contract_Ccy_Limit UNION ALL 
select DISTINCT 'OUTW_RI_Contract_Ins' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_RI_Contract_Ins UNION ALL 
select DISTINCT 'OUTW_Risk' as  ViewName, Date_of_Load, Reporting_Flag from [DATALIBLEG-SQLDB-01-UKS-TEST].[datalibleg-sqldb-01-uks-test].[RS].OUTW_Risk