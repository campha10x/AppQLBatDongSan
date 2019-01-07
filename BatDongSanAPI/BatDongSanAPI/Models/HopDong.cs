using System;
namespace BatDongSanAPI.Models
{
    public class HopDong
    {
        private BatDongSanStoreContext context;

        public String IdHopDong { get; set; }
        public String IdChuCanHo { get; set; }
        public String IdCanHo { get; set; }
        public String SoTienCoc { get; set; }
        public String NgayBD { get; set; }
        public String NgayKT { get; set; }
        public String GhiChu { get; set; }
        public String IdKhachHang { get; set; }
        public String TienDien { get; set; }
        public String TienNuoc { get; set; }
        public String SoDienBd { get; set; }
        public String SoNuocBd { get; set; }
    }
}
