<?php
/**
 * Cof
 *
 * Content on First (paginate page): Show a document field, a chunk or a Tv only on first paginate page
 *
 * @category	snippet
 * @version     1.1
 * @internal	@modx_category Content
 * @author      Author: Nicola Lambathakis http://www.tattoocms.it/
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal @installset base, sample
 * @lastupdate  11-10-2024
 */
// examples:
// Show a document field only on first page
// [[Cof? &paginate=`page` &field=`content` &Message=`@TPL:GoBack`]]
// or
// [[Cof? &paginate=`page` &field=`content` &Message=`<a class="btn btn-default" href="[~[*id*]~]"><i class="fa fa-arrow-left"></i> Back to the first page</a>`]]
// Show a chunk only on first page
// [[Cof? &paginate=`page` &chunk=`TopNews` &Message=`@TPL:GoBack`]]
// Show a Template Vartiable only on first page
// [[Cof? &paginate=`page` &Tv=`MyTv` &Message=`@TPL:GoBack`]]
// Show and Render a Template Vartiable only on first page
// [[Cof? &paginate=`page` &Tv=`MyTv` &RenderTv=`1` &Message=`@TPL:GoBack`]]
	
$paginate = (isset($paginate)) ? $paginate : 'page'; // Default pagination parameter
$field = (isset($field)) ? $field : 'content'; // Default field to return
$chunk = (isset($chunk)) ? $chunk : ''; // Optional chunk to return
$Tv = (isset($Tv)) ? $Tv : ''; // Optional Template Variable (TV) to return
$RenderTv = (isset($RenderTv)) ? (bool)$RenderTv : false; // Defines whether to render the TV
$Message = (isset($Message)) ? $Message : ''; // Optional message or chunk for pages with pagination parameter
$output = ''; // Initialize output

// Check if the pagination parameter is present in the URL (e.g. ?page=2)
if (isset($_GET[$paginate])) {
    // If the pagination parameter is present and the Message is defined
    if (!empty($Message)) {
        if (strpos($Message, '@TPL:') === 0) {
            // If the Message starts with "@TPL:", call the chunk
            $chunkName = str_replace('@TPL:', '', $Message); // Remove "@TPL:" from the chunk name
            $output = $modx->getChunk($chunkName); // Return the specified chunk
        } else {
            // Otherwise, treat the Message as HTML and return it directly
            $output = $Message;
        }
    }
} else {
    // If the pagination parameter is not present, check what content to return
    if (!empty($chunk)) {
        // If a chunk is defined, return it
        $output = $modx->getChunk($chunk);
    } elseif (!empty($Tv)) {
        // If a TV is defined, check whether it should be rendered
        if ($RenderTv) {
            // Return the rendered TV
            $tvOutput = $modx->getTemplateVarOutput($Tv, $modx->documentIdentifier);
            $output = isset($tvOutput[$Tv]) ? $tvOutput[$Tv] : "TV '$Tv' does not exist.";
        } else {
            // Return the raw value of the TV
            $tv = $modx->getTemplateVar($Tv, '*', $modx->documentIdentifier);
            $output = ($tv['value'] != '') ? $tv['value'] : $tv['defaultText'];
        }
    } elseif (!empty($field)) {
        // If a field is defined, return it
        $output = isset($modx->documentObject[$field]) ? $modx->documentObject[$field] : "Field '$field' does not exist.";
    }
}

return $output;