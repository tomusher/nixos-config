#!/home/tom/.pyenv/shims/python
import sys
import httpx

def do_nl(*args):
    log_string = " ".join(args)
    httpx.post('https://myapi.home.tomusher.com/notion/log', json={"name": log_string})
    print("Log added")

def do_nt(*args):
    task_string = " ".join(args)
    httpx.post('https://myapi.home.tomusher.com/notion/task', json={"name": task_string})
    print("Task added")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        args = sys.argv[1].split(" ")
        function = f"do_{args[0]}"
        locals()[function](*args[1:])
    else:
        for l in list(locals()):
            if l.startswith('do_'):
                print(l.replace('do_', ''))

