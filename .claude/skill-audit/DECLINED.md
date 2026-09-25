# Declined audit findings

The ledger of what the maintainer decided not to change after a `/skill-audit` run, so the next run does not raise it again. One line each: the file and the text the finding was about, the pattern it was raised under, and the reason it was declined — `- <file> "<quoted text>" (<lens/pattern>) — <reason>, <date>`. The auditors drop a finding that matches a line here unless they carry new evidence against its reason; a line whose file or text no longer exists can be deleted.
