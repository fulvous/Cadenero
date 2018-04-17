#!/bin/bash -x

#Cadenero.sh crea un firewall sencillo para servidor Asterisk
#Copyright (C) 2018 Leon Ramos @fulvous
#
#
#Cadenero.sh es software libre: Puede redistribuirlo y/o 
#modificarlo bajo los terminos de la Licencia de uso publico 
#general GNU de la Fundacion de software libre, ya sea la
#version 3 o superior de la licencia.
#
#Cadenero.sh es distribuida con la esperanza de que sera util,
#pero sin ningun tipo de garantia; inclusive sin la garantia
#implicita de comercializacion o para un uso particular.
#Vea la licencia de uso publico general GNU para mas detalles.
#
#Deberia de recibir uan copia de la licencia de uso publico
#general junto con Cadenero.sh, de lo contrario, vea
#<http://www.gnu.org/licenses/>.
#
#This file is part of Cadenero.sh
#
#Cadenero.sh is free software: you can redistribute it and/or 
#modify it under the terms of the GNU General Public License 
#as published by the Free Software Foundation, either version 3 
#of the License, or any later version.
#
#Cadenero.sh is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with Cadenero.sh  If not, see 
#<http://www.gnu.org/licenses/>.

IPT="/sbin/iptables"
LAN="192.168.1.0/24"

$IPT -P INPUT ACCEPT
$IPT -P OUTPUT ACCEPT
$IPT -F

#Permitir el loopback
$IPT -I INPUT 1 -i lo -j ACCEPT

#Permitiendo el trafico regresar
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#Permitir acceso al puerto 2222
$IPT -A INPUT -p tcp --dport 2222 -j ACCEPT

#Permite RTP
$IPT -A INPUT -p udp -m udp --dport 10000:20000 -j ACCEPT

#Permite adicionales
$IPT -A INPUT -p udp -m udp --dport 2727 -j ACCEPT
$IPT -A INPUT -p udp -m udp --dport 4569 -j ACCEPT

#Permite Trafico local
$IPT -A INPUT -s $LAN -p udp -m udp --dport 5060:5061 -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 5060:5061 -j ACCEPT
$IPT -A INPUT -s $LAN -p icmp -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 137 -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 138 -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 139 -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 445 -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 10000 -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 22 -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 123 -j ACCEPT
$IPT -A INPUT -s $LAN -p udp -m udp --dport 123 -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 5038 -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 58080 -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 55050 -j ACCEPT
$IPT -A INPUT -s $LAN -p tcp -m tcp --dport 514 -j ACCEPT
$IPT -A INPUT -s $LAN -p udp -m udp --dport 514 -j ACCEPT

#Permite entrar al administrador
$IPT -A INPUT -p tcp --dport 80 -j ACCEPT
$IPT -A INPUT -p tcp --dport 443 -j ACCEPT

#Cierra el resto del trafico
$IPT -A INPUT -j DROP
