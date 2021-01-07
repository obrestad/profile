class profile::certtest {
  profile::letsencrypt::certificate { 'testcert':
    domains => [
      'fjas.rothaugane.com',
    ]
  }
}
