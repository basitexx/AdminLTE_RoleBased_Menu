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
    
    public partial class tbl_Patient
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public tbl_Patient()
        {
            this.tbl_ImagingOrder = new HashSet<tbl_ImagingOrder>();
            this.tbl_InjectionOrder = new HashSet<tbl_InjectionOrder>();
            this.tbl_LaboratoryOrder = new HashSet<tbl_LaboratoryOrder>();
            this.tbl_PatientHistory = new HashSet<tbl_PatientHistory>();
            this.tbl_Prescription = new HashSet<tbl_Prescription>();
            this.tbl_Visit = new HashSet<tbl_Visit>();
        }
    
        public int ID { get; set; }
        public string FullName { get; set; }
        public Nullable<System.DateTime> DateOfBirth { get; set; }
        public string Gender { get; set; }
        public string PhoneNo { get; set; }
        public Nullable<int> SubCity { get; set; }
        public Nullable<int> Woreda { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tbl_ImagingOrder> tbl_ImagingOrder { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tbl_InjectionOrder> tbl_InjectionOrder { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tbl_LaboratoryOrder> tbl_LaboratoryOrder { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tbl_PatientHistory> tbl_PatientHistory { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tbl_Prescription> tbl_Prescription { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tbl_Visit> tbl_Visit { get; set; }
    }
}
