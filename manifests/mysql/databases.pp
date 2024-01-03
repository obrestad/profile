# Configures mysql-databases based on hiera
class profile::mysql::databases {
  $databases = lookup('profile::mysql::databases', {
    'default_value' => {},
    'value_type'    => Hash,
  })

  $databases.each | $dbname, $data | {
    mysql::db { $dbname:
      * => $data,
    }
  }
}
