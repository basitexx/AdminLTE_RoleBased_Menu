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
    
    public partial class tbl_OrderStatus
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public tbl_OrderStatus()
        {
            this.tbl_ImagingOrder = new HashSet<tbl_ImagingOrder>();
            this.tbl_InjectionOrder = new HashSet<tbl_InjectionOrder>();
            this.tbl_LaboratoryOrder = new HashSet<tbl_LaboratoryOrder>();
        }
    
        public int ID { get; set; }
        public string OrderStatus { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tbl_ImagingOrder> tbl_ImagingOrder { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tbl_InjectionOrder> tbl_InjectionOrder { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tbl_LaboratoryOrder> tbl_LaboratoryOrder { get; set; }
    }
}
