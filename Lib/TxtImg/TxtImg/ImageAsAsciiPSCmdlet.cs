using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

namespace TxtImg
{

    [Cmdlet(VerbsCommon.Get, "ImageAsAscii")]
    public class ImageAsAsciiPSCmdlet : PSCmdlet
    {

        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true,
            HelpMessage = "The image's URL"
        )]
        public string Url { get; set; }

        protected override void ProcessRecord()
        {
            WriteObject(API.ImageToString(this.Url));
        }
    }
}
