class GlobalTable1 {
  int maxBlockNetUsage;
  int targetBlockNetUsagePct;
  int maxTransactionNetUsage;
  int basePerTransactionNetUsage;
  int netUsageLeeway;
  int contextFreeDiscountNetUsageNum;
  int contextFreeDiscountNetUsageDen;
  int maxBlockCpuUsage;
  int targetBlockCpuUsagePct;
  int maxTransactionCpuUsage;
  int minTransactionCpuUsage;
  int maxTransactionLifetime;
  int deferredTrxExpirationWindow;
  int maxTransactionDelay;
  int maxInlineActionSize;
  int maxInlineActionDepth;
  int maxAuthorityDepth;
  int maxRamSize;
  int totalRamBytesReserved;
  int totalRamStake;
  DateTime lastProducerScheduleUpdate;
  DateTime lastPervoteBucketFill;
  int pervoteBucket;
  int perblockBucket;
  int totalUnpaidBlocks;
  String totalActivatedStake;
  DateTime threshActivatedStakeTime;
  int lastProducerScheduleSize;
  double totalProducerVoteWeight;
  DateTime lastNameClose;

  GlobalTable1({
    required this.maxBlockNetUsage,
    required this.targetBlockNetUsagePct,
    required this.maxTransactionNetUsage,
    required this.basePerTransactionNetUsage,
    required this.netUsageLeeway,
    required this.contextFreeDiscountNetUsageNum,
    required this.contextFreeDiscountNetUsageDen,
    required this.maxBlockCpuUsage,
    required this.targetBlockCpuUsagePct,
    required this.maxTransactionCpuUsage,
    required this.minTransactionCpuUsage,
    required this.maxTransactionLifetime,
    required this.deferredTrxExpirationWindow,
    required this.maxTransactionDelay,
    required this.maxInlineActionSize,
    required this.maxInlineActionDepth,
    required this.maxAuthorityDepth,
    required this.maxRamSize,
    required this.totalRamBytesReserved,
    required this.totalRamStake,
    required this.lastProducerScheduleUpdate,
    required this.lastPervoteBucketFill,
    required this.pervoteBucket,
    required this.perblockBucket,
    required this.totalUnpaidBlocks,
    required this.totalActivatedStake,
    required this.threshActivatedStakeTime,
    required this.lastProducerScheduleSize,
    required this.totalProducerVoteWeight,
    required this.lastNameClose,
  });

  factory GlobalTable1.fromJson(Map<String, dynamic> json) {
    return GlobalTable1(
      maxBlockNetUsage: json['max_block_net_usage'],
      targetBlockNetUsagePct: json['target_block_net_usage_pct'],
      maxTransactionNetUsage: json['max_transaction_net_usage'],
      basePerTransactionNetUsage: json['base_per_transaction_net_usage'],
      netUsageLeeway: json['net_usage_leeway'],
      contextFreeDiscountNetUsageNum:
          json['context_free_discount_net_usage_num'],
      contextFreeDiscountNetUsageDen:
          json['context_free_discount_net_usage_den'],
      maxBlockCpuUsage: json['max_block_cpu_usage'],
      targetBlockCpuUsagePct: json['target_block_cpu_usage_pct'],
      maxTransactionCpuUsage: json['max_transaction_cpu_usage'],
      minTransactionCpuUsage: json['min_transaction_cpu_usage'],
      maxTransactionLifetime: json['max_transaction_lifetime'],
      deferredTrxExpirationWindow: json['deferred_trx_expiration_window'],
      maxTransactionDelay: json['max_transaction_delay'],
      maxInlineActionSize: json['max_inline_action_size'],
      maxInlineActionDepth: json['max_inline_action_depth'],
      maxAuthorityDepth: json['max_authority_depth'],
      maxRamSize: int.parse(json['max_ram_size']),
      totalRamBytesReserved: json['total_ram_bytes_reserved'],
      totalRamStake: json['total_ram_stake'],
      lastProducerScheduleUpdate:
          DateTime.parse(json['last_producer_schedule_update']),
      lastPervoteBucketFill: DateTime.parse(json['last_pervote_bucket_fill']),
      pervoteBucket: json['pervote_bucket'],
      perblockBucket: json['perblock_bucket'],
      totalUnpaidBlocks: json['total_unpaid_blocks'],
      totalActivatedStake: json['total_activated_stake'],
      threshActivatedStakeTime:
          DateTime.parse(json['thresh_activated_stake_time']),
      lastProducerScheduleSize: json['last_producer_schedule_size'],
      totalProducerVoteWeight:
          double.parse(json['total_producer_vote_weight'].toString()),
      lastNameClose: DateTime.parse(json['last_name_close']),
    );
  }
}
