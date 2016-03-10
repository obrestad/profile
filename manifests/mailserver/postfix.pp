class profile::mailserver::postfix {
  $mail_mynetworks = hiera("profile::mail::mynetworks")
}
