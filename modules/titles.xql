xquery version "3.1";

(: 
 : Building on day 02 we go forward with the model to produce a title listing
 :
 :)

(:===
Declare namespaces
==:)
declare namespace hoax = "http://obdurodon.org/hoax";
declare namespace m = "http://www.obdurodon.org/model";
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
declare variable $articles-coll := collection($path-to-data || '/hoax_xml');
declare variable $articles as element(tei:listPlace)+ := $articles-coll/tei:listPlace;

<m:titles> 
{
    for $article in $articles 
    return
        <m:title>
        { 
            $article//tei:titleStmt/tei:title ! fn:string(.)
        }
        </m:title>
}
</m:titles>