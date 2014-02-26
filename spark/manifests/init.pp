class spark (

    $spark_install_dir     = '/opt/spark',
    $scala_install_dir     = '/opt/scala',
    $web_port        = 8080,
    $cores           = undef,
    $memory          = undef,
    $scratch_dir     = "${install_dir}/work",
    $worker_mem      = 2g,
    $hadoop_library  = '/usr/lib/hadoop/lib/native:$SPARK_LIBRARY_PATH',
    $hadoop_conf_dir = '/etc/hadoop/conf/',
    $yarn_conf_dir   = '/etc/hadoop/conf/',
    $hadoop_home     = '/usr/lib/hadoop/',
    $spark_jar       = '/opt/spark/assembly/target/scala-2.10/spark-assembly_2.10-0.9.0-incubating-hadoop2.2.0.jar'

) {
    
    require spark::user
    
    file {$scala_install_dir:
        ensure  => directory,
        source  => "puppet:///modules/spark/scala",
        mode    => '0744',
        recurse => true,
        owner   => 'root',
        group   => 'root',
        require => User['spark'],
    }

    file {$spark_install_dir:
        ensure  => directory,
        source  => "puppet:///modules/spark/spark",
        mode    => '0744',
        recurse => true,
        owner   => 'root',
        group   => 'root',
        require => User['spark'],
    }

    file {"${spark_install_dir}/conf/spark-env.sh":
        content => template('spark/spark-env.sh.erb'),
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        require => File[$spark_install_dir],
    } 
    
    file {"${spark_install_dir}/conf/log4j.properties":
        content => template('spark/log4j.properties.erb'),
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        require => File[$spark_install_dir],
    } 

    #file {"${spark_install_dir}/conf/metrics.properties":
    #    content => template('spark/metrics.properties.erb'),
    #    mode    => '0744',
    #    owner   => 'root',
    #    group   => 'root',
    #    require => File[$spark_install_dir],
    #} 

    # Create log dir for logging.
    file {'/var/log/spark':
        ensure => directory,
        owner   => 'root',
        group   => 'root',
    }

}
