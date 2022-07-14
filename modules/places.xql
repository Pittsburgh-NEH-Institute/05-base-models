xquery version "3.1";

(: 
 : By copying Leif-Jöran's module from yesterday (notice that we're saving these as modules now!), we can easily adapt and expand on existing code.
 :)

(:===
Declare namespaces
==:)
declare namespace hoax = "http://obdurodon.org/hoax";
declare namespace hoax-model = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(:===
Declare global variables to path
===:)
declare variable $exist:root as xs:string := 
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := 
    request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';
(:===
Declare variable
===:)
declare variable $place-coll := doc($path-to-data || '/aux_xml/places.xml');
declare variable $places as element(tei:place)+ := $place-coll//tei:place;

<hoax-model:places> 
{
    for $place in $places
        let $name as xs:string* := $place/tei:placeName ! string(.)
        let $geo as element(tei:geo)? := $place/tei:location/tei:geo
        let $lat as xs:double := substring-before($geo, " ") ! number(.)
        let $long as xs:double := substring-after($geo, " ") ! number(.)
        where $geo
    return
        <hoax-model:place>
            <hoax-model:name>
                {$name}
            </hoax-model:name>
            <hoax-model:geo>
                <hoax-model:lat>{$lat}</hoax-model:lat>
                <hoax-model:long>{$long}</hoax-model:long>
                
            </hoax-model:geo>
        </hoax-model:place>
}
</hoax-model:places>