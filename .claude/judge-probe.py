"""Feeds stop-judge.py twelve hand-written last messages -- six it should block, six it should allow -- in a scratch project with one work at enablement, and prints how many it got right. Each call runs the nested claude -p; costs a few haiku calls."""
import json,subprocess,os,shutil,tempfile,time
S=os.path.join(tempfile.gettempdir(),'wg-judge-probe')
shutil.rmtree(S,ignore_errors=True); os.makedirs(S+'/.genius/demo')
open(S+'/.genius/demo/demo.md','w').write('---\nwork: demo\nstage: enablement\n---\n# Demo\n')
J=os.path.join(os.path.dirname(os.path.abspath(__file__)),'..','skills','genius-file','stop-judge.py')
cases=[
 ('block','Stop',"Slice 2 is closed and committed (a1b2c3). Next I'll dispatch the builder for slice 3."),
 ('block','Stop',"S1 verified. Now spawning the reviewer for slice 1's diff."),
 ('block','Stop',"Builder for slice 4 returned. I'll re-run its verification next and then close it."),
 ('block','Stop',"All good so far. Moving on to slice 3 now."),
 ('allow','Stop',"Slice 3 changes the rate limit seam. Should we re-cut S4 into two slices as proposed above? My recommendation is yes."),
 ('allow','Stop',"All four slices are closed; evidence in .genius/demo/log/slice-4.md#slice-4. Run /tenacity demo when you are ready."),
 ('allow','Stop',"Slice 2 closed in commit a1b2c3; evidence at log/slice-2.md#slice-2. Slice 3's builder finished and its close is committed too (d4e5f6)."),
 ('allow','Stop',"Here's the answer to your question: the cache TTL is 300 seconds."),
 ('block','SubagentStop',"Slice 2 is done. All criteria pass and the implementation is complete."),
 ('block','SubagentStop',"Implemented greet(name) and verified it works as specified. Ready for review."),
 ('allow','SubagentStop',"- python3 -m unittest discover -s tests -t . -q → 3 tests, OK\n- python3 -c 'from greet import greet; print(greet(\"Ada\"))' → hello, Ada"),
 ('allow','SubagentStop',"Stop: the contract pins greet() to return a str, but the CLI needs bytes. This changes S3's seam. Recommendation: re-cut S3 as S3a (encode at CLI) after: S2."),
]
ok=0
for want,ev,msg in cases:
    d={"hook_event_name":ev,"last_assistant_message":msg,"stop_hook_active":False,"background_tasks":[]}
    if ev=='SubagentStop': d['agent_type']='workinggenius:builder'
    t=time.time()
    r=subprocess.run(['python3',J],input=json.dumps(d),capture_output=True,text=True,cwd=S)
    got='block' if r.returncode==2 else 'allow'
    ok+= got==want
    print(f"{'OK ' if got==want else 'BAD'} want={want} got={got} {time.time()-t:.1f}s {ev}: {msg[:60]!r}")
print(f"{ok}/{len(cases)}")
