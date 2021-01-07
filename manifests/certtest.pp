class profile::certtest {
  profile::letsencrypt::certificate { 'testcert':
    domains => [
      'fjas.rothaugane.com',
    ]
  }
  profile::letsencrypt::certificate { 'wildcardtestcert':
    domains => [
      'obrestad.org',
      '*.obrestad.org',
    ]
  }
}
