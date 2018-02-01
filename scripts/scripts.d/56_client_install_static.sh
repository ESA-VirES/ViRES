#!/bin/sh
#-------------------------------------------------------------------------------
#
# Purpose: VirES client installation
# Author(s): Martin Paces <martin.paces@eox.at>
#-------------------------------------------------------------------------------
# Copyright (C) 2015 EOX IT Services GmbH

. `dirname $0`/../lib_logging.sh
. `dirname $0`/../lib_util.sh
. `dirname $0`/../lib_eoxserver.sh

info "Adding VirES client to static files..."

set_instance_variables

required_variables STATIC_DIR CONTRIB_DIR VIRES_INSTALL_USER VIRES_INSTALL_GROUP

# locate the installation package
FNAME="`lookup_package "$CONTRIB_DIR/"{WebClient-Framework,VirES-Client}"*.tar.gz"`"
[ -n "$FNAME" ] || {
    warn "Failed to locate the client installation package."
    warn "The client installation is skipped."
    exit 0
}

info "Installation package located in: $FNAME"

INSTALL_DIR="${STATIC_DIR}/workspace/"

# remove the previous installation
[ -d "$INSTALL_DIR" ] && rm -fR "$INSTALL_DIR"

# extract archive in a temporary directory
create_and_enter_tmp_dir
tar -xzf "$FNAME"

# move the extracted directory to the final destination
ROOT="`find "$PWD" -mindepth 1 -maxdepth 1 -type d \( -name 'VirES-Client*' -o -name 'WebClient-Framework*' \) | head -n 1`"
chown -R "$VIRES_INSTALL_USER:$VIRES_INSTALL_GROUP" "$ROOT"
mv -f "$ROOT" "$INSTALL_DIR"

info "VirES Client installed to: $INSTALL_DIR"
