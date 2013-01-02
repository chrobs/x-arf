require 'x-arf.rb'

i={}
i[:mail] = {:to => "to@t.de", :from => "from@t.de", :cc => "cc@t.de", :bcc => "bcc@t.de", :reply_to => "rep_to@t.de", :errors_to => "err@t.de", :subject => "testsubject"}
i[:template] = "ssh-scan-parser.text.erb"
i[:report] = {
                "Reported-From" => "me@test.de",
                "Category" => "abuse",
                "Report-Type" => "login-attack",
                "Service" => "SSH",
                "Version" => 0.1,
                "User-Agent" => "XarfMail 0.1",
                "Date" => Time.now.to_s,
                "Source-Type" => "ipv4",
                "Source" => "1.1.1.26",
                "Port" => 22,
                "Report-ID" => "12675788150797@xarfmail.de",
                "Schema-URL" => "http://www.x-arf.org/schema/abuse_login-attack_0.1.1.json",
                "Attachment" => "text/plain",
                "Occurrences" => 2,
                "TLP" => "amber"
}
i[:logs] = [
            "Jun  3 22:46:06 1.1.8.4 20367287: Jun  3 22:46:05.119 MEZS: %SEC-6-IPACCESSLOGP: list in.TenGigabitEthernet1_1_1 denied tcp 58.254",
            "Jun  3 22:46:06 1.1.35.114 60687: Jun  3 22:46:05.139 MEZS: %SEC-6-IPACCESSLOGP: list in.Vlan627 denied tcp 58.254.250.42(35456) ->",
            "Jun  3 22:46:07 1.1.1.2 440651: Jun  3 22:46:06.410 MEZS: %SEC-6-IPACCESSLOGP: list in.Vlan776 denied tcp 58.254.250.42(35456) -> 1"
]
i[:hostname] = "bad.hostname.de"

x = XarfMail.new i
puts x.build_mail.encoded
#f = File.new("/tmp/x-arf_email_#{Time.now.to_i}", 'w')
#f.puts x.build_mail.encoded
#f.close
