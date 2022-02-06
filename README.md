# Dockerisierter fastd Client

Der fastd-Container verbindet sich mit ein oder mehreren peers im Freifunk-Netz via fastd und startet batman-adv,
um das peering herzustellen. Über diese Verbindung können IPV6-Broadcasts der Knoten empfangen werden, um
daraus Kartendaten zu ermitteln.

Umgebungsvariablen:

* `FASTD_MTU` (benötigt): MTU der fastd-Verbindung
* `FASTD_PEER1_NAME` (default: peer1): Name des ersten peers
* `FASTD_PEER1_REMOTE` (benötigt): Remote-Adresse des Peers in fastd Syntax, z.B. "gluon20162a61.leipzig.freifunk.net" port 1006
* `FASTD_PEER1_KEY` (benötigt): öffentlicher Schlüssel des Peers
* `FASTD_PEERn_NAME` (optional): weitere Peers (fortlaufend numeriert)
* `FASTD_LOG_LEVEL` (default: info)
* `IPV6_PREFIX` (optional): Prefix für radvd, nötig um hosts im Netz über ihre nicht-link-lokale IPv6 anzupingen. z.B. `fdef:ffc0:7030::/64`

Um IPv6 zu unterstützen, müssen für den Container die folgenden SysCtls gesetzt sein:

`net.ipv6.conf.all.disable_ipv6=0`
`net.ipv6.conf.all.forwarding=1`
