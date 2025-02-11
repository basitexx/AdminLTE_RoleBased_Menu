//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ProjectMain.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tbl_PatientHistory
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public tbl_PatientHistory()
        {
            this.tbl_PatientHistoryOrders = new HashSet<tbl_PatientHistoryOrders>();
        }
    
        public int ID { get; set; }
        public Nullable<int> PatientID { get; set; }
        public Nullable<int> DoctorID { get; set; }
        public Nullable<int> VisitID { get; set; }
        public string DoctorComment { get; set; }
        public Nullable<System.DateTime> LastUpdate { get; set; }
    
        public virtual tbl_Patient tbl_Patient { get; set; }
        public virtual tbl_Staff tbl_Staff { get; set; }
        public virtual tbl_Visit tbl_Visit { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tbl_PatientHistoryOrders> tbl_PatientHistoryOrders { get; set; }
    }
}
