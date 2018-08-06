if [ $# -lt 2 ] ;then
            echo "$0 put|get file"
                    exit 0
                fi
                file=$2
                #command_file='.ftp.script.tmp'
                command_file='ftp.tmp'
                echo "open 172.24.23.127 21" > $command_file
                echo "user pubftp look" >> $command_file
                echo "binary" >> $command_file
                if [ $1 == 'put' ] ; then
                            echo "put $file" >> $command_file
                        elif [ $1 == 'get' ] ; then
                                    echo "get $file" >> $command_file
                                else
                                            echo "$0 put|get file"
                                                    exit 0
                                                fi
                                                echo "bye"      >> $command_file
                                                ftp -i -in <  $command_file
                                                rm -rf $command_file
