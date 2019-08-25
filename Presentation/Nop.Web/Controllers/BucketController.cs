using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Nop.Core;
using Nop.Core.Domain.Buckets;
using Nop.Core.Domain.Catalog;
using Nop.Services.Buckets;
using Nop.Services.Catalog;
using Nop.Services.Security;
using Nop.Web.Framework.Mvc.Filters;
using Nop.Web.Models.Buckets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Nop.Web.Controllers
{
    public class BucketController : BasePublicController
    {
        private IBucketService _BucketService;
        private IBucketTypeService _BucketTypeService;
        private IBucketItemService _BucketItemService;
        private IProductService _ProductService;
        private IWorkContext _workContext;
        private IPermissionService _permissionService;
        #region Ctor

        public BucketController(IBucketService BucketService,
           IBucketTypeService productTemplateService,
           IBucketTypeService BucketTypeService,
           IBucketItemService BucketItemService,
          IProductService ProductService,
        //    IUrlRecordService urlRecordService,
           IWorkContext workContext,
        //    ILanguageService languageService,
        //    ILocalizationService localizationService,
        //    ILocalizedEntityService localizedEntityService,
        //    ISpecificationAttributeService specificationAttributeService,
        //    IPictureService pictureService,
        //    ITaxCategoryService taxCategoryService,
        //    IProductTagService productTagService,
        //    ICopyProductService copyProductService,
        //    IPdfService pdfService,
        //    IExportManager exportManager,
        //    IImportManager importManager,
        //    ICustomerActivityService customerActivityService,
           IPermissionService permissionService
        //    IAclService aclService,
        //    IStoreService storeService,
        //    IOrderService orderService,
        //    IStoreMappingService storeMappingService,
        //    IVendorService vendorService,
        //    IDateRangeService dateRangeService,
        //    IShippingService shippingService,
        //    IShipmentService shipmentService,
        //    ICurrencyService currencyService,
        //    CurrencySettings currencySettings,
        //    IMeasureService measureService,
        //    MeasureSettings measureSettings,
        //    IStaticCacheManager cacheManager,
        //    IDateTimeHelper dateTimeHelper,
        //    IDiscountService discountService,
        //    IProductAttributeService productAttributeService,
        //    IBackInStockSubscriptionService backInStockSubscriptionService,
        //    IShoppingCartService shoppingCartService,
        //    IProductAttributeFormatter productAttributeFormatter,
        //    IProductAttributeParser productAttributeParser,
        //    IDownloadService downloadService,
        //    ISettingService settingService,
        //    TaxSettings taxSettings,
        //    VendorSettings vendorSettings
        )

        {
            this._BucketService = BucketService;
            //this._productTemplateService = productTemplateService;
            this._BucketTypeService = BucketTypeService;
            this._BucketItemService = BucketItemService;
            this._ProductService = ProductService;
            //this._urlRecordService = urlRecordService;
            this._workContext = workContext;
            //this._languageService = languageService;
            //this._localizationService = localizationService;
            //this._localizedEntityService = localizedEntityService;
            //this._specificationAttributeService = specificationAttributeService;
            //this._pictureService = pictureService;
            //this._taxCategoryService = taxCategoryService;
            //this._productTagService = productTagService;
            //this._copyProductService = copyProductService;
            //this._pdfService = pdfService;
            //this._exportManager = exportManager;
            //this._importManager = importManager;
            //this._customerActivityService = customerActivityService;
            this._permissionService = permissionService;
            //this._aclService = aclService;
            //this._storeService = storeService;
            //this._orderService = orderService;
            //this._storeMappingService = storeMappingService;
            //this._vendorService = vendorService;
            //this._dateRangeService = dateRangeService;
            //this._shippingService = shippingService;
            //this._shipmentService = shipmentService;
            //this._currencyService = currencyService;
            //this._currencySettings = currencySettings;
            //this._measureService = measureService;
            //this._measureSettings = measureSettings;
            //this._cacheManager = cacheManager;
            //this._dateTimeHelper = dateTimeHelper;
            //this._discountService = discountService;
            //this._productAttributeService = productAttributeService;
            //this._backInStockSubscriptionService = backInStockSubscriptionService;
            //this._shoppingCartService = shoppingCartService;
            //this._productAttributeFormatter = productAttributeFormatter;
            //this._productAttributeParser = productAttributeParser;
            //this._downloadService = downloadService;
            //this._settingService = settingService;
            //this._taxSettings = taxSettings;
            //this._vendorSettings = vendorSettings;
        }

        #endregion
        public virtual IActionResult Index()
        {
           List<Bucket> buckets =_BucketService.GetAllBuckets().ToList();
            return View(buckets);
        }
        public virtual IActionResult Details(int id)
        {
            Bucket buckets = _BucketService.GetBucketById(id);
            return View(buckets);
        }

        public virtual IActionResult Create()
        {
            BucketModel bucket = new BucketModel();
            bucket.DueDate = DateTime.Now;
            bucket.IsActive = true;
            var buckettypes = _BucketTypeService.GetAllBucketTypes();
            bucket.bucketTypes = buckettypes.Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Type }).ToList();
            bucket.BucketTypeId= buckettypes.Select(s => s.Id).FirstOrDefault();
            return View(bucket);
        }

        [HttpPost]
        public virtual IActionResult Create(BucketModel model)
        {
            //  if (!_permissionService.Authorize(StandardPermissionProvider.AllowCustomerImpersonation))
            //    return AccessDeniedView();
            Bucket bucket = new Bucket();
            bucket.CustomerId = 189458;
            bucket.BucketDeleted = false;
            bucket.BucketDesc = model.BucketDesc;
            bucket.BucketTitle = model.BucketTitle;
            bucket.BucketTypeId = model.BucketTypeId;
            bucket.CreateDate = DateTime.Now;
            bucket.DueDate = model.DueDate;
            bucket.IsActive = model.IsActive;
            bucket.StatusId = 1;

            if (ModelState.IsValid)
            { }
            _BucketService.InsertBucket(bucket);
            
            return RedirectToAction("create");
        }
        public virtual int AddItemToBucket(int itemId)
        {
            Product product = _ProductService.GetProductById(itemId);
          
            BucketItem bucketItem = _BucketItemService.CheckIfExists(Utilities.BucketSelected, itemId);
            if (bucketItem != null)
            { bucketItem.Quantity += 1;
                bucketItem.TotalPrice = bucketItem.Quantity * product.Price;
                _BucketItemService.UpdateBucket(bucketItem);
            }

            else
            {

                bucketItem = new BucketItem();

                bucketItem.BucketId = Utilities.BucketSelected;
                bucketItem.AddDate = DateTime.Now;
                bucketItem.ProductId = itemId;
                bucketItem.UnitPrice = product.Price;
                bucketItem.Quantity = 1;
                bucketItem.TotalPrice = product.Price;

                _BucketItemService.InsertBucket(bucketItem);

             
             
            }
            Bucket bucket = _BucketService.GetBucketById(Utilities.BucketSelected);

            bucket.BucketAmount += bucketItem.UnitPrice;
            _BucketService.UpdateBucket(bucket);
            return _BucketItemService.CountItemsByBucketId(Utilities.BucketSelected);
        }
        public virtual IActionResult DeleteItem(int id , int delType)
        {
            BucketItem bucketItem = _BucketItemService.GetItemById(id);
            Bucket bucket = bucketItem.Bucket;
            if (delType==1 && bucketItem.Quantity>1)
            {
             
                bucketItem.Quantity -= 1;
                bucketItem.TotalPrice -= bucketItem.UnitPrice;
                _BucketItemService.UpdateBucket(bucketItem);
                bucket.BucketAmount -= bucketItem.UnitPrice;
            }
           else
            {
                bucket.BucketAmount -= bucketItem.TotalPrice;
                _BucketItemService.DeleteItemById(id);

            }
            _BucketService.UpdateBucket(bucket);
            return RedirectToAction("Details",new {id= bucket.Id });
        }

        public virtual IActionResult Edit(int id)
        {
            Bucket Bucket = _BucketService.GetBucketById(id);
            BucketModel bucket = new BucketModel()
            {
                BucketDesc = Bucket.BucketDesc,
                BucketTitle = Bucket.BucketTitle,
                DueDate = Bucket.DueDate,
                IsActive = Bucket.IsActive,
                BucketTypeId=Bucket.BucketTypeId
            };
            var buckettypes = _BucketTypeService.GetAllBucketTypes();
            bucket.bucketTypes = buckettypes.Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Type }).ToList();
            return View(bucket);
        }
        [HttpPost]
        public virtual IActionResult Edit(int id,BucketModel bucket)
        {
            Bucket Bucket = _BucketService.GetBucketById(id);
            
            Bucket.BucketDesc = bucket.BucketDesc;
            Bucket.BucketTitle = bucket.BucketTitle;
            Bucket.BucketTypeId = bucket.BucketTypeId;
            Bucket.DueDate = bucket.DueDate;
            Bucket.IsActive = bucket.IsActive;
            _BucketService.UpdateBucket(Bucket);
            return RedirectToAction("Index");
        }
        public virtual IActionResult Delete(int id)
        {
            Bucket Bucket = _BucketService.GetBucketById(id);

           
            return View(Bucket);
        }
        [HttpPost]
        public virtual IActionResult Delete(int id, BucketModel bucket)
        {
            Bucket Bucket = _BucketService.GetBucketById(id);
            
            Bucket.BucketDeleted = true;
            _BucketService.UpdateBucket(Bucket);
            return RedirectToAction("Index");
        }
    }
}
