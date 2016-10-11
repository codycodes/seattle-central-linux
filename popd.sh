      DIR_STACK=${DIR_STACK#* }
      cd ${DIR_STACK%% *}
      echo "$PWD"

