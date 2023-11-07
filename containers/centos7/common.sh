# common settings

export POD_PORT="8200"
export POD_NAME="vires-server-dev"

list_images() {
    cat - << END
centos7
ingress
database
django-base
oauth-base
oauth
swarm-base
swarm
END
}

. ./tag.conf
