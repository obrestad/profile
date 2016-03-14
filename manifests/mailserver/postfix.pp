class profile::mailserver::postfix {
  class { '::postfix':
    master_smtp => 'smtp inet n - n - - smtpd',
    master_smtps => 'smtps inet n - n - - smtpd',
    master_submission => 'submission inet n - n - - smtpd',
    mta => true,
	relayhost => 'direct',
  }
}
