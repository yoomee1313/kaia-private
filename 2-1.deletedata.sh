source ./properties.sh
cd $HOMEDIR

if [ $# -eq 2 ]; then
  echo ${1} ${2}
  rm -rf ${1}${2}/data/klay/chaindata/ ${1}${2}/data/klay/LOCK ${1}${2}/data/klay/transactions.rlp
  rm -rf ${1}${2}/data/k${1} ${1}${2}/data/logs
  exit
fi

for ((num = 1; num <= `find . -maxdepth 1 -type d -name 'cn*' | wc -l`; num++))
do
  rm -rf cn$num/data/klay/chaindata/ cn$num/data/klay/LOCK cn$num/data/klay/transactions.rlp
  rm -rf cn$num/data/kcn cn$num/data/logs
done

for ((num = 1; num <= `find . -maxdepth 1 -type d -name 'pn*' | wc -l`; num++))
do
  rm -rf pn$num/data/klay/chaindata/ pn$num/data/klay/LOCK pn$num/data/klay/transactions.rlp
  rm -rf pn$num/data/kpn pn$num/data/logs
done

for ((num = 1; num <= `find . -maxdepth 1 -type d -name 'en*' | wc -l`; num++))
do
  rm -rf en$num/data/klay/chaindata/ en$num/data/klay/scchaindata en$num/data/klay/LOCK en$num/data/klay/transactions.rlp
  rm -rf en$num/data/ken en$num/data/logs
done

