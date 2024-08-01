#!/bin/bash
source ./properties.sh

pushd .
trap 'popd' EXIT
cd $HOMEDIR

# Function to check if a command exists
command_exists() {
  source ~/.bashrc
  command -v "$1" >/dev/null 2>&1
}

# Check and install Prometheus
install_prometheus() {
  if command_exists prometheus; then
    echo "Prometheus is already installed."
  else
    echo "Installing Prometheus..."
    curl -LO https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.darwin-amd64.tar.gz
    tar xvfz prometheus-2.43.0.darwin-amd64.tar.gz
    rm -rf $HOMEDIR/prometheus && mv prometheus-2.43.0.darwin-amd64 $HOMEDIR/prometheus && rm -rf $HOMEDIR/prometheus-2.43.0.darwin-amd64 && rm -rf $HOMEDIR/prometheus-2.43.0.darwin-amd64.tar.gz
    echo "export PATH=\"$HOMEDIR/prometheus:\$PATH\"" >> ~/.bashrc && source ~/.bashrc
  fi
  cp klaytn-deploy/grafana/prometheus.yml $HOMEDIR/prometheus/prometheus.yml # Copy Prometheus configuration file from klaytn-deploy
}


# Check and install Grafana
install_grafana() {
  if command_exists grafana-server; then
    echo "Grafana is already installed."
  else
    echo "Installing Grafana..."
    curl -O https://dl.grafana.com/enterprise/release/grafana-enterprise-8.4.5.darwin-amd64.tar.gz
    tar -zxvf grafana-enterprise-8.4.5.darwin-amd64.tar.gz && mv grafana-8.4.5 grafana
    echo "export PATH=\"$HOMEDIR/prometheus:\$PATH\"" >> ~/.bashrc && source ~/.bashrc
  fi

  # Copy Grafana configuration files from klaytn-deploy
  cp klaytn-deploy/grafana/*.json grafana/conf/provisioning/dashboards/
  cp klaytn-deploy/grafana/klaytn-dashboard.yaml grafana/conf/provisioning/dashboards/
  cp klaytn-deploy/grafana/klaytn.yaml grafana/conf/provisioning/datasources/
}

install() {
  # Clone the klaytn-deploy repository if not already cloned
  if [ ! -d "klaytn-deploy" ]; then
      echo "Cloning klaytn-deploy repository..."
      git clone https://github.com/klaytn/klaytn-deploy.git
  fi

  install_prometheus
  install_grafana
}

start() {
  source ~/.bashrc

  # Start Prometheus
  echo "Starting Prometheus..."
  prometheus --config.file=$HOMEDIR/prometheus/prometheus.yml &

  # Start Grafana
  echo "Starting Grafana..."
  grafana-server --config $HOMEDIR/grafana/conf/sample.ini &
}

stop() {
  source ~/.bashrc

  echo "Stopping Prometheus..."

  # Find and kill Prometheus process
  PROMETHEUS_PID=$(pgrep prometheus)

  if [ -n "$PROMETHEUS_PID" ]; then
      kill "$PROMETHEUS_PID"
      echo "Prometheus stopped."
  else
      echo "Prometheus is not running."
  fi

  echo "Stopping Grafana..."
  brew services stop grafana
}

# Check the argument and call the corresponding function
case "$1" in
    install)
        install
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    *)
        echo "Usage: $0 {install|start|stop}"
        exit 1
        ;;
esac