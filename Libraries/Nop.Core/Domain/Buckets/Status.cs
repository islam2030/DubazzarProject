﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nop.Core.Domain.Buckets
{
    public class Status : BaseEntity
    {
        public string status { get; set; }
        public virtual ICollection<Bucket> _Buckets { get; set; }
        public virtual ICollection<Bucket> Buckets
        {
            get { return _Buckets ?? (_Buckets = new List<Bucket>()); }
            protected set { _Buckets = value; }
        }

    }
}
