#' Uniprot entry class.
#'
#' This is the entry class for Uniprot database.
#'
#' @examples
#' # Create an instance with default settings:
#' mybiodb <- biodb::Biodb()
#'
#' # Create a connector
#' conn <- mybiodb$getFactory()$createConn('uniprot')
#'
#' # Get an entry
#' e <- conn$getEntry('P01011')
#'
#' # Terminate instance.
#' mybiodb$terminate()
#'
#' @export UniprotEntry
#' @exportClass UniprotEntry
UniprotEntry <- methods::setRefClass("UniprotEntry",
    contains="BiodbXmlEntry",

methods=list(

.isContentCorrect=function(content) {
    return( ! grepl("^<!DOCTYPE html ", content, perl=TRUE))
},

.parseFieldsStep2=function(parsed.content) {

    # Remove new lines from sequence string
    if (.self$hasField('aa.seq'))
        .self$setFieldValue('aa.seq',
                            gsub("\\n", "", .self$getFieldValue('aa.seq')))

    # Get synonyms
    ns <- .self$getParent()$getPropertyValue('xml.ns')
    synonyms <- XML::xpathSApply(parsed.content,
                                 "//uniprot:protein//uniprot:fullName",
                                 XML::xmlValue, namespaces=ns)
    if (length(synonyms) > 0)
        .self$appendFieldValue('name', synonyms)
}

))