
DROP TABLE IF EXISTS #INWDimRisk_DimBureauNonBureauSwitchCategory;
TRUNCATE TABLE QA.TMP_DIM_OUTW_RISK;

SELECT distinct DimBureauNonBureauSwitchCategoryID 
  into #INWDimRisk_DimBureauNonBureauSwitchCategory
  FROM [Eclipse_EXT].[fn_LatestRITCBureauNonBureauSwitch]();


;WITH Limit AS(
SELECT [DimPolicyID],[DimLimitCurrencyID]
      ,SUM([Limit100PctLimitCcy])  AS [Limit100PctLimitCcy]
	  ,SUM([Excess100PctLimitCcy]) AS [Excess100PctLimitCcy]
	  ,LimitBasisCode              AS LimitBasis--, @int_DataHistoryId
  FROM ECLIPSE_MI.[FactPolicyLimit100Pct] lfpl
		INNER JOIN Eclipse_mi.dimlimitDetails dl ON dl.DImlimitDetailid=lfpl.DImlimitDetailid
		INNER JOIN #INWDimRisk_DimBureauNonBureauSwitchCategory RF ON RF.DimBureauNonBureauSwitchCategoryID = lfpl.DimBureauNonBureauSwitchCategoryID
 WHERE dl.TopLimitInd = 'Top Limit' AND Lfpl.DimDataHistoryID = 3305
   AND lfpl.DimBureauNonBureauSwitchCategoryID IN ( SELECT DimBureauNonBureauSwitchCategoryID FROM [Eclipse_EXT].[fn_LatestRITCBureauNonBureauSwitch]())
 GROUP BY [DimPolicyID],[DimLimitCurrencyID],LimitBasisCode
	)

	
INSERT INTO QA.TMP_DIM_OUTW_RISK(
 [RISK_ID] 					    
,[FULL_UW_REF] 				    
,[TOI_CODE] 					    
,[MAJOR_CLASS]                   
,[MINOR_CLASS]                   
,[SUB_CLASS]                     
,[PERIOD_OF_POLICY_FROM_DATE]    
,[PERIOD_OF_POLICY_TO_DATE]      
,[INSURED_NAME]                  
,[INSURER_NAME] 				    
,[INSURER_ID] 				    
,[UNIQUE_MARKET_REF]             
,[SIGNED_LINE_PCT]               
,[SIGNED_ORDER_PCT]              
,[WRITTEN_LINE_PCT]              
,[WRITTEN_ORDER_PCT]             
,[ESTIMATED_SIGNING_PCT]         

,[OCCURRING_OR_ATTACHING_CODE]   
,[TERRITORIAL_SCOPE] 			
,[INSURED_TERRITORIAL_SCOPE]     
,[ACCOUNT_NUM]                   
,[BKR_PSEUDONYM]                 
,[BKR_NAME]    
,[CONTRACT_TYPE_CODE]            
,[CONTRACT_TYPE_DESC]            
,[RISK_STATUS_CODE]              
,[COVERHOLDER_NAME]              
,[REINST_TERMS_DESC]             
,[RISK_SECTION_CCY_LIMIT_CODE]   
,[RISK_SECTION_CCY_LIMIT_AMT]    
,[XL_EXCESS_AMT]                 
,[LIMIT_BASIS]                   
,[LEADER_STATUS]                 
,[REPORTING_FLAG]                
)



	SELECT DISTINCT
		DPL.[First_DimPolicyGranularDetailID] AS [RISK_ID],
		DP.[PolicyReference]					AS [FULL_UW_REF] ,
		CASE WHEN [DPBG].[PlacingBasisGroup] = 'Reinsurance' 
		     THEN 'R' ELSE 'I' END							AS [TOI_CODE],	
		[DP].[StatsMajorClassDescription]                   AS [MAJOR_CLASS],
		[DP].[StatsMinorClassDescription]                   AS [MINOR_CLASS],

		[DP].[SubClassDescription]							AS [SUB_CLASS],
		DP.[InceptionDate]									AS [PERIOD_OF_POLICY_FROM_DATE],
		cast(DP.[ExpiryDate] AS Date)						AS [PERIOD_OF_POLICY_TO_DATE],
		-- Verify 
		CASE WHEN [DPBG].[PlacingBasisGroup] = 'Reinsurance' 
		     THEN '' ELSE DP.[AssuredName] END				AS [INSURED_NAME],
		-- Verify 
		CASE WHEN [DPBG].[PlacingBasisGroup] = 'Reinsurance' 
		     THEN DP.[AssuredName] ELSE '' END				AS [INSURER_NAME],
		-- Verify
		0													AS [INSURER_ID],
		[DP].[UniqueMarketRef]                              AS [UNIQUE_MARKET_REF],

		[DPL].[SignedLinePct]                               AS [SIGNED_LINE_PCT],
		[DPL].[SignedOrderPct]                              AS [SIGNED_ORDER_PCT],
		[DPL].[WrittenLinePct]                              AS [WRITTEN_LINE_PCT],
		[DPL].[WrittenOrderPct]                             AS [WRITTEN_ORDER_PCT],
		[DPL].[EstimatedSignedPct]                          AS [ESTIMATED_SIGNING_PCT],

		[DP].[CoverageBasis]                                AS [OCCURRING_OR_ATTACHING_CODE],
		[DT].[AggregatesTerritoryCode]                      AS [TERRITORIAL_SCOPE],
		[DT].[AggregatesTerritoryCode]                      AS [INSURED_TERRITORIAL_SCOPE],
		[DB].[BRMBrokerCode]                                AS [ACCOUNT_NUM],
		[DB].[BRMBrokerPseudonym]                             AS [BKR_PSEUDONYM],
		[DB].[BrokerName]                                   AS [BKR_NAME],

		[DPB].[PlacingBasis]                                AS [CONTRACT_TYPE_CODE],
		DPB.PlacingBasisDescription                         AS [CONTRACT_TYPE_DESC],
		[DPS].[GroupPolicyStatus]                           AS [RISK_STATUS_CODE],
		dp.Coverholder                                      AS [COVERHOLDER_NAME] ,
		[DP].[ReinstatementBasis]                           AS [REINST_TERMS_DESC],
----
		ISNULL([DLC].[MasterDataCurrencyISOCode],'')        AS [RISK_SECTION_CCY_LIMIT_CODE],
		ISNULL([FL].[Limit100PctLimitCcy],0)                AS [RISK_SECTION_CCY_LIMIT_AMT],
		ISNULL([FL].[Excess100PctLimitCcy],0)               AS [XL_EXCESS_AMT],
		ISNULL([FL].[LimitBasis],'')                        AS [LIMIT_BASIS],
		ISNULL(DL.GroupLeaderStatus,'')                     AS [LEADER_STATUS],

		

		 dlf.ORILegatumFlag                                 AS REPORTING_FLAG	

	FROM [DWH_MI].[FactORITransaction] FT 

	INNER JOIN [DWH_MI].[DimORIPlacement] OP ON OP.[DimORIPlacementID] =FT.[DimORIPlacementID]
	INNER JOIN DWH.DimORILegatumFlag DLF ON dlf.DimORILegatumFlagID=FT.DimORILegatumFlagID
	INNER JOIN DWH_MI.[DimPolicyGranularDetail] DPL ON [FT].[DimPolicyGranularDetailID] = DPL.[DimPolicyGranularDetailID]
	LEFT JOIN [DWH_MI].[DimPolicy] DP ON	FT.[DimPolicyID] = DP.[DimPolicyID]	
	LEFT JOIN [DWH_MI].[DimGroupClass] DGC ON [DGC].[DimGroupClassID] = [DPL].[DimGroupClassID]
	LEFT JOIN (SELECT DISTINCT DimPolicyGranularDetailID,DimLeaderStatusID 
	             FROM DWH_mi.LatestBridgePolicyGranularDetail) BPGD 
				 ON  BPGD.DimPolicyGranularDetailID=DPL.DimPolicyGranularDetailID
	LEFT JOIN DWH_MI.DimLeaderStatus DL ON  DL.DimLeaderStatusID=BPGD.DimLeaderStatusID
	LEFT JOIN [DWH_MI].[DimPlacingBasis] DPB ON [DPB].[DimPlacingBasisID] = DP.[DimPlacingBasisID]
	LEFT JOIN [DWH_MI].[DimPlacingBasisGroup] DPBG ON [DPBG].[DimPlacingBasisGroupID] = [DPB].[DimPlacingBasisGroupID]
	LEFT JOIN [DWH_MI].[DimTerritory] DT ON DT.[DimTerritoryID] = [ft].[DimTerritoryID]
	LEFT JOIN [DWH_MI].[DimBroker] DB ON DB.[DimBrokerID] = [FT].[DimBrokerID]
	LEFT JOIN [DWH_MI].[DimPolicyStatus] DPS ON [DPS].[DimPolicyStatusID] = [FT].[DimPolicyStatusID]
	LEFT JOIN Limit FL 	ON [FL].[DimPolicyID] = [DP].[DimPolicyID]
	LEFT JOIN [DWH_MI].[DimCurrency] DLC ON [DLC].[DimCurrencyID] = FL.[DimLimitCurrencyID]	
	LEFT JOIN [Eclipse_EXT].[fn_LatestRITCBureauNonBureauSwitch]() BNB ON BNB.DimBureauNonBureauSwitchCategoryID = DP.[DimBureauNonBureauSwitchCategoryID]
WHERE DLF.ORILegatumFlag <>'Retained' 
  AND FT.DimDataHistoryID = 3305
  AND OP.[ORIContractType] IN ('FP','FX')
  AND DP.[PolicyReference] <> 'UNK'


[RISK_ID] 					     [int] NULL,
[FULL_UW_REF] 				     [nvarchar](128) NULL,
[TOI_CODE] 					     [nvarchar](1) NULL,
[MAJOR_CLASS]                    [nvarchar](512) NULL,
[MINOR_CLASS]                    [nvarchar](512) NULL,
[SUB_CLASS]                      [nvarchar](512) NULL,
[PERIOD_OF_POLICY_FROM_DATE]     [date] NULL,
[PERIOD_OF_POLICY_TO_DATE]       [date] NULL,
[INSURED_NAME]                   [nvarchar](512) NULL,
[INSURER_NAME] 				     [nvarchar](512) NULL,
[INSURER_ID] 				     [int] NULL,
[UNIQUE_MARKET_REF]              [nvarchar](128) NULL,
[SIGNED_LINE_PCT]                [decimal](10, 7) NULL,
[SIGNED_ORDER_PCT]               [decimal](10, 7) NULL,
[WRITTEN_LINE_PCT]               [decimal](10, 7) NULL,
[WRITTEN_ORDER_PCT]              [decimal](10, 7) NULL,
[ESTIMATED_SIGNING_PCT]          [decimal](10, 7) NULL,
[OCCURRING_OR_ATTACHING_CODE]    [nvarchar](512) NULL,
[TERRITORIAL_SCOPE] 			 [nvarchar](128) NULL,
[INSURED_TERRITORIAL_SCOPE]      [nvarchar](512) NULL,
[ACCOUNT_NUM]                    [nvarchar](128) NULL,
[BKR_PSEUDONYM]                  [nvarchar](128) NULL,
[BKR_NAME]                       [nvarchar](512) NULL,
[CONTRACT_TYPE_CODE]             [nvarchar](512) NULL,
[CONTRACT_TYPE_DESC]             [nvarchar](512) NULL,
[RISK_STATUS_CODE]               [nvarchar](128) NULL,
[COVERHOLDER_NAME]               [nvarchar](512) NULL,
[REINST_TERMS_DESC]              [nvarchar](max) NULL,
[RISK_SECTION_CCY_LIMIT_CODE]    [nvarchar](10) NULL,
[RISK_SECTION_CCY_LIMIT_AMT]     [decimal](19, 4) NULL,
[XL_EXCESS_AMT]                  [decimal](19, 4) NULL,
[LIMIT_BASIS]                    [nvarchar](10) NULL,
[LEADER_STATUS]                  [nvarchar](512) NULL,
[REPORTING_FLAG]                 [nvarchar](128) NULL,
