setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export PROJNAME=ddev-gitpod-setup
  export TESTDIR=~/tmp/${PROJNAME}
  mkdir -p $TESTDIR
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev start
}

health_checks() {
  # Check we manage the file.
  grep '#ddev-generated' "${TESTDIR}/.gitpod.yml"
  # Check the base .gitpod.yml file is included.
  grep 'image: ddev/ddev-gitpod-base' "${TESTDIR}/.gitpod.yml"
  # Check project-type tasks are included.
  grep 'ddev start -y' "${TESTDIR}/.gitpod.yml"
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get ${DIR}
  ddev restart
  health_checks

  # We added custom removal code, so lets check that it works.
  ddev add-on remove ${DIR}
  if test -f "${TESTDIR}/.gitpod.yml"; then
    echo "'${TESTDIR}/.gitpod.yml' exists but it should NOT."
    exit 1;
  fi
}

@test "it configures gitpod for Laravel" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev config --project-type=laravel
  ddev add-on get ${DIR}

  health_checks
  grep -q 'ddev artisan key:generate' "${TESTDIR}/.gitpod.yml"
}

@test "it generates file with custom projectType" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev config --project-type=laravel

  # Add a custom setup config for Laravel
  mkdir -p "${TESTDIR}/.ddev/gitpod-setup"
  cp "$DIR/tests/testdata/custom-laravel.yml" "${TESTDIR}/.ddev/gitpod-setup/laravel.yml"

  ddev add-on get ${DIR}

  health_checks
  grep -q 'ddev artisan key:generate' "${TESTDIR}/.gitpod.yml"
  grep -q 'Custom Laravel Gitpod' "${TESTDIR}/.gitpod.yml"
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev add-on get tyler36/ddev-gitpod-setup with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get tyler36/ddev-gitpod-setup
  ddev restart >/dev/null
  health_checks
}

@test "it configures gitpod for Drupal" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev config --project-type=drupal
  ddev add-on get ${DIR}

  health_checks
  grep -q 'ddev drush si -y' "${TESTDIR}/.gitpod.yml"
}
