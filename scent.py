from sniffer.api import file_validator, runnable
import os
import termstyle


pass_fg_color = termstyle.green
pass_bg_color = termstyle.bg_default
fail_fg_color = termstyle.red
fail_bg_color = termstyle.bg_default


watch_paths = ['blackjack/', 'tests/', './scent.py']


@file_validator
def py_files(filename):
    return (filename.endswith('.py') and
            not os.path.basename(filename).startswith('.'))


@runnable
def execute_manage_test(*args):
    import os
    os.system('env/bin/coverage erase')
    exit_code = os.system(
        'env/bin/coverage run --rcfile=coverage.cfg -m unittest discover ./tests'
    )
    os.system('env/bin/coverage report --rcfile=coverage.cfg')
    os.system('env/bin/coverage html --rcfile=coverage.cfg; touch htmlcov')
    return exit_code == 0
