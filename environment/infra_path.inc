script_link="$( readlink "$BASH_SOURCE" )" || script_link="$BASH_SOURCE"
apparent_sdk_dir="${script_link%/*}"
if [ "$apparent_sdk_dir" == "$script_link" ]; then
  apparent_sdk_dir=.
fi

infra_dir="$( command cd -P "$apparent_sdk_dir" > /dev/null && pwd -P )"
bin_path="$infra_dir/packer:""$infra_dir/terraform:""$infra_dir/consul:""$infra_dir/nomad"
export PATH=$bin_path:$PATH