x-arf
=====

send mail in extended Abuse Reporting Format (x-arf) v0.1. For more information on x-arf see http://www.x-arf.org/

written for/tested with ruby-1.8.6-p420 and ruby-1.8.5 (2006-08-25)

## infos
instantiate regular with Xarf.new(opt) where opt is a ruby hash with the following parameters:
  * **:mail** [HASH] - ruby Hash with the parameters:
    * **:to** [STRING] - list of recipients, comma separated
    - **:from** [STRING]
    - **:reply_to** [STRING]
    - **:cc** [STRING] - list of CC-recipients, comma separated
    - **:bcc** [STRING] - list of BCC-recipients, comma separated
    - **:errors_to** [STRING]
    - **:subject** [STRING]
  * **:template** [STRING] - full name of template file within "mail-views/" folder
  * **:report** [HASH] - ruby hash with parameters:
    - **"Reported-From"** [STRING], mandatory - needs to contain the sending e-mail address
    - **"Category"** [STRING], mandatory - one of the following categories: abuse, fraud, auth, info, private (more info see http://www.x-arf.org/specification.html)
    - **"Report-Type"** [STRING], mandatory - type of report, for example: login-attack, phishing-website, spamvertized, etc
    - **"User-Agent"** [STRING], mandatory - Name and version of the generating software (see RFC 1945 and RFC 2068)
    - **"Report-ID"** [STRING], mandatory - unique identifier for this specific incident with reasonable domain part, e.g. "abuse-1357127996@yourdomain.ltd"
    - **"Date"** [STRING], mandatory - date of the incident itself in RFC 3339 or RFC 2822
    - **"Source-Type"** [STRING], mandatory - ipv4, ipv6, uri, domain or email
    - **"Source"** [STRING], mandatory - source of abusive behavior. It is described by <Source-Type:>
    - **"Attachment"** [STRING], mandatory - only "none" or "text/plain" allowed
    - **"Schema-URL"** [STRING], mandatory - uri to the JSON-schema that describes the content of the report, e.g. "http://www.x-arf.org/schema/abuse_login-attack_0.1.1.json"
    - **"Version"** [STRING], optionally - version of specification (current is 0.1)
    - **"Occurrences"** [STRING], optionally -  Though each incident should be reported on its own, this field may be used to consolidate incidents which are strongly related to each other, e.g. "14"
    - **"TLP"** [STRING], optionally - may be used to indicate the sensitivity of the information in the report: red, amber, green or white
  * **:logs** [ENUMERATOR] - each inner element represents one log line and supports "to\_s". For example an array with Strings.

####classes
* [HASH] has to be a ruby Hash or at least an object which implements the keywords
* [STRING] has to be a ruby String or any object which implements the "to\_s" method
* [ENUMERATOR] may be any object which supports the "each" method
