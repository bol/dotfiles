# Set a sensible default if locale is not set
if [[ -z "$LC_ALL" ]]; then
  export LC_ALL='en_US.UTF-8'
fi
