<?php
/**
 * Cof
 *
 * Cof - Content on First (page)
 *
 * @category	snippet
 * @internal	@modx_category Admin
 * @version     1.0
 * @author      Author: Nicola Lambathakis http://www.tattoocms.it/
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal @installset base, sample
 * @lastupdate  11-10-2024
 */
// examples:
// [[Cof? &paginate=`start` &field=`content` &Message=`@TPL:GoBack`]]
// [[Cof? &paginate=`start` &field=`content` &Message=`<a class="btn btn-default" href="[~[*id*]~]"><i class="fa fa-arrow-left"></i> Torna alla pagina iniziale</a>`]]
	
$paginate = (isset($paginate)) ? $paginate : 'page'; // Default parametro per la paginazione
$field = (isset($field)) ? $field : 'content'; // Default campo da restituire
$Message = (isset($Message)) ? $Message : ''; // Messaggio o chunk opzionale
$output = ''; // Inizializza l'output

// Controlla se il parametro di paginazione è presente nell'URL es: ?page=2
if (isset($_GET[$paginate])) {
    // Se il parametro è presente e il message è definito
    if (!empty($Message)) {
        if (strpos($Message, '@TPL:') === 0) {
            // Se il message inizia con "@TPL:", richiama il chunk
            $chunkName = str_replace('@TPL:', '', $Message); // Rimuove "@TPL:" dal nome del chunk
            $output = $modx->getChunk($chunkName); // Restituisce il chunk specificato
        } else {
            // Altrimenti considera il message come HTML e restituiscilo direttamente
            $output = $Message;
        }
    }
} else {
    // Se il parametro non è presente, restituisci il campo specificato
    if (isset($modx->documentObject[$field])) {
        $output = $modx->documentObject[$field]; // Output del campo
    } else {
        $output = "Field '$field' does not exist."; // Messaggio di errore se il campo non è trovato
    }
}

return $output;
