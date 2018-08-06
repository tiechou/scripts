#!/bin/bash

base_home=$(readlink -f "$(dirname "$0")")
redis="redis-2.0.4"
redis_home=${base_home}/${redis}

hostname="10.232.41.72 10.232.41.135"

echo "begin to scp redis ..."
tarball="${base_home}/${redis}-$(date +%Y%m%d).tar.gz"
echo "tar -C ${base_home} -czf ${tarball} ${redis}"

tar -C "${base_home}" -czf "${tarball}" "${redis}"

for host in ${hostname}; do
    echo "scp -r ${tarball} $host:${tarball}"
    scp -r "$tarball" "$host:${tarball}"
    
    echo "ssh $host tar -zxf ${tarball}"
    ssh $host tar -zxf ${tarball}
    
    echo "ssh -f $host ${redis_home}/bin/start_redis.sh"
    ssh "$host" "${redis_home}/bin/start_redis.sh"
done
echo "handout redis ok"

exit 0
