# Desplegar un cluster k3s
Desplegaremos el cluster en 4 vm, una master y 3 worker. Para crearlas
usaremos vagrants, lo que nos permitira automatizar su creación, permitiendo asi
que esta sea más reproducible y facilitando su despliegue.
Actualmente esta programado para un despliegue de las 4 máquinas en local, pero se puede hacer que sea en remoto y hasta en dsitribuido, todo ello ejecutando comandos dese tu ordenador.

Para lanzarlo solo se debe ejecutar el comando 
```bash 
vagrant up
```
en el mismo directorio que el fichero vagrantfile, este crrara las máquinas virtuales con
ubuntu. (en caso de no tener el comando instalarlo, yo lo he hecho con pacman).
Tras ello ya tenemos el cluster montado, puede probarse su funcionamiento con
```bash 
./kubectl get pod
./kubectl apply -f https://raw.githubusercontent.com/openshift-evangelists/kbe/master/specs/pods/pod.yaml
./kubectl get pod

```
# Errores comunes
 - La interfaz de red no es correcta: en el vagrabt file line 25 se pone la 
interfaz puente con las vm, poner una disponible en el ordenador host.
 - Máquinas virtuales inaccesibles: No estarán en tu red local, modificar las Ips de la linea 9-14
