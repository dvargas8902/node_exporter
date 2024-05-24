###############################################
#######   REVISAR ARCHIVO DE ERRORES   #######
###############################################

export log_file=/opt/alertaerrorescron/Log_Errores_$(date +%Y%-m%-d).txt
ultimalinea=`cat $log_file | wc -l`

# Validacion de existencia de archivo ultima leida 
if [ -e /opt/alertaerrorescron/ultimaleida.txt ]
then
	ultimaleida=`cat /opt/alertaerroreslogs/ultimaleida.txt`
else
	echo "0" > "/opt/alertaerrorescron/ultimaleida.txt"
    export ultimaleida="0"
fi

# Determinar a partir de cual linea se debe revisar
if linealert=`expr $ultimalinea - $ultimaleida`

then
# Busco las coincidencias y las escribo en un archivo
tail -n $linealert $log_file | grep "Bad request"> /opt/alertaerrorescron/errores_encontrados.txt

#Modifico el achivo que almacena la linea de la ultima coincidencia encontrada
ultimaleida=`grep -n "Error" $log_file | cut -d: -f1 | tail -1`
echo $ultimaleida > "/opt/alertaerrorescron/ultimaleida.txt"

else 

#Envio de email
export ASUNTO=PRUEBA
export smtp=172.23.1.100:25
export ORIGEN=AlertaSockets@grupokonecta.com
export DESTINO=dvargas@konecta-group.com
mail -r "AlertaSockets@grupokonecta.com" -s "Errores Socket" -a "/opt/alertaerroreslogs/errores_encontrados.txt" "$DESTINO" < "/opt/alertaerroreslogs/errores_encontrados.txt"

