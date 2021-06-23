# Installs the weechat client 
class profile::clients::irssi {
  package { [
    'weechat',
    'weechat-curses',
    'weechat-plugin',
  ]:
    ensure  => 'present',
  }
}
