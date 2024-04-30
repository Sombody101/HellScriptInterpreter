using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BashHellScript;

internal enum ExitStatus
{
    Success,
    ScriptNotFound,
    FailedToFetchProjectInformation,
    EmptyStack
}
