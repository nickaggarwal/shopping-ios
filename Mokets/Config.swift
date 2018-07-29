//
//  config.swift
//  Mokets
//
//  Created by Panacea-soft on 11/23/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

struct configs {
    

    static var mainUrl:String = "http://www.panacea-soft.com/mokets-demo/index.php/rest"
    //static var mainUrl:String = "http://localhost/mokets-admin/index.php/rest"
    
    static var imageUrl:String = "http://www.panacea-soft.com/mokets-demo/uploads/"
    //static var imageUrl:String = "http://192.168.1.2:8888/mokets-admin/uploads/"
   
    static let getShops           = "/shops/get"
    static let getShopByID        = "/shops/get/id/%d"
    static let itemsBySubCategory = "/items/get/shop_id/%d/sub_cat_id/%d/item/all/count/%d/from/%d"
    static let allItemsBySubCategory = "/items/get/shop_id/%d/sub_cat_id/%d/item/all/"
    static let itemById              = "/items/get/id/%d/shop_id/%d"
    static let searchByGeo           = "/items/search_by_geo/miles/%f/userLat/%f/userLong/%f/shop_id/%d/sub_cat_id/%d"
    static let userLogin           = "/appusers/login"
    static let getFavouriteItems   = "/items/user_favourites/user_id/%d/count/%d/from/%d"
    static let addItemInquiry      = "/items/inquiry/id/%d"
    static let addItemReview       = "/items/review/id/%d"
    static let addAppUser          = "/appusers/add"
    static let resetPassword       = "/appusers/reset"
    static let updateAppUser       = "/appusers/update/id/%d"
    static let profilePhotoUpload  = "/images/upload"
    static let addItemLike         = "/items/like/id/%d"
    static let isLikedItem         = "/items/is_like/id/%d"
    static let isFavouritedItem    = "/items/is_favourite/id/%d"
    static let addItemFavourite    = "/items/favourite/id/%d"
    static let addItemTouch        = "/items/touch/id/%d"
    static let getNewsFeedByShopId = "/shops/feeds/shop_id/%d"
    static let searchByKeyword     = "/items/search/shop_id/%d"
    static let registerPushNoti    = "/gcm/register"
    static let addItemRating       = "/items/rating/id/%d"
    static let stripePayment       = "/stripe/submit"
    static let transactionSubmit   = "/transactions/add"
    static let userTransactionHistory     = "/transactions/user_transactions/user_id/%d"
    static let getAbout             = "/abouts/index"
    
    static var pageSize:Int = 7
    static var barColorCode = "#E64A19"
    
    // Connection timeout Interval seconds
    static var timeoutInterval = 5
    
    // iAds flag
    //static var showAdvs = true // true or false
}

struct language {
    static var LoginTitle              = "Login"
    static var blankInputLogin         = "Please provide your login credential."
    static var emailValidation         = "Please check your email format."
    static var loginNotSuccessMessage  = "Sorry, please try again to login in."
    static var profileUpdate           = "Profile Update"
    static var doNotMatch              = "New Passwrod and Confirm Password do not match."
    static var reviewTitle             = "Review"
    static var reviewEmpty             = "Please type your review"
    static var inquiryTitle            = "Inquiry"
    static var inquiryEmpty            = "Please provide necesssary input"
    static var typeInquiryMessage      = "Please type inquiry here..."
    static var typeReviewMessage       = "Please type review here..."
    static var inquirySentSuccess      = "Inquiry has been sent succesfully"
    static var somethingWrong          = "API response something wrong. Please try agian."
    static var currentLocation         = "Current Location"
    static var geocoderProblem         = "Oops! Problem to get your location information."
    static var searchTitle             = "Search"
    static var itemNotFount            = "Sorry, items are not found. Please search again."
    static var allowLocationService    = "Please allow location service."
    static var homePageTitle           = "Mokets"
    static var searchPageTitle         = "Keyword Search"
    static var profilePageTitle        = "Profile"
    static var registerTitle           = "Register"
    static var userInputEmpty          = "Please provide necessary user information."
    static var registerSuccess         = "Your account registeration is successful. You are ready to login."
    static var resetTitle              = "Forgot Password"
    static var resetSuccess            = "Next instruction has been sent to your registerred email."
    static var userEmailEmpty          = "Please provide your registered email."
    static var tryAgainToConnect       = "Oops! Server could not response. Please try again."
    static var networkError            = "Oops! Can't connect to internet"
    static var imageIsNull             = "Oops! selected image is blank."
    static var itemMapTitle            = "Map View"
    static var noLatLng                = "There is no latitude and longitude for this item. Please provide it."
    static var shareMessage            = "Mokets is solution to build Mobile Commerce App easily."
    static var fbLogin                 = "Please login to a Facebook account to share."
    static var twLogin                 = "Please login to a Twitter account to share."
    static var btnOK                   = "OK"
    static var accountLogin            = "Account Login"
    static var categories              = "Categories : "
    static var subCategories           = " | Sub Categories : "
    static var selectedCityPageTitle   = "Selected Shop"
    static var itemsPageTitle          = "Items From Shop"
    static var itemDetailPageTitle     = "Item Detail"
    static var shareOn                 = "Share"
    static var tweetOn                 = "Tweet"
    static var viewOnMap               = "View"
    static var inquiryPageTitle        = "Item Inquiry"
    static var reviewListPageTitle     = "Reviews List"
    static var submit                  = "Submit"
    static var reviewEntryPageTitle    = "Submit Review"
    static var feedListPageTitle       = "News Feed From Shop"
    static var feedDetailPageTitle     = "News Feed Detail"
    static var mapExplorePageTitle     = "Explore On Map"
    static var itemMapPageTitle        = "Item Location"
    static var sliderPageTitle         = "Item Images"
    static var favouritePageTitle      = "My Favourite Items"
    static var homeMenu                = "Home"
    static var searchMenu              = "Search By Keyword"
    static var ProfileMenu             = "Profile"
    static var favouriteMenu           = "My Favourite Items"
    static var logoutMenu              = "Logout"
    static var forgotTitle             = "Request Forgot Password"
    static var loginRequireTitle       = "Login Required"
    static var loginRequireMesssage    = "You need to login first to do this action."
    static var noShops                = "There is no available shop in the system. Please add from Backend."
    static var profilePhotoUploaded    = "Profile photo successfully updated."
    static var mileRange               = "Miles Range : "
    static var miles                   = " ml"
    static var shareURL                = "http://codecanyon.net/user/panacea-soft"
    static var price                   = "Price : "
    static var qty                     = "Qty : "
    static var rating                  = "Rating : "
    static var na                      = "N.A"
    static var availableDiscount       = "Available Discount : "
    static var availableDiferent       = "Available Different "
    static var selectedAttribute       = "Selected Attribute : "
    static var addtoCart               = "Add To Cart"
    static var fillQtyMessage          = "Please fill quantity for add to cart."
    static var basketEmptyTitle        = "Basket Empty"
    static var basketEmptyMessage      = "Please add item into basket first."
    static var total                   = "Total : "
    static var paymentOptionsTitle     = "Payment Options"
    static var checkoutConfirmationTitle = "Checkout Confirmation"
    static var paymentTitle            = "Payment"
    static var userInfoRequired        = "User Information are required for checkout process."
    static var orderSuccessMessage     = "Your order has been submitted."
    static var orderSuccessTitle       = "Success"
    static var orderFailMessage        = "Sorry, your order could not submit."
    static var orderFailTitle          = "Fail"
    static var shopProfile             = "Shop Profile"
    static var transactionHistory      = "Transaction History"
    static var transactionNo           = "Transaction No : "
    static var transactionStatus       = "Status : "
    static var transactionTotal        = "Total Amount : "
    static var transactionHistoryDetail      = "Transaction History Detail"
    static var transactionPhone        = "Phone : "
    static var transactionEmail        = "Email : "
    static var transactionBilling      = "Billing Address : "
    static var transactionDelivery     = "Delivery Address : "
    static var transactionItemName     = "Item Name : "
    static var alreadyRated            = "Sorry, you are already provided the rating."
    static var ratingTitle            = "Rating"
    static var ratingProblem          = "Sorry, there is the issue for rating process."
    static var aboutPageTitle         = "About App"
    static var basketTitle             = "Basket"
    static var basketMessage           = "Qty must have at least one"
    static var offlineTitle            = "Device Offline"
    static var offlineMessage          = "Sorry, internet connection is required."
    
    
}

struct notiKey {
    static var deviceIDKey = "DEVICE_ID"
    static var deviceTokenKey = "TOKEN"
    static var isRegister = "IS_REGISTER"
    static var notiMessageKey = "NOTI_MSG"
    static var devicePlatform = "IOS"
}

struct customFont{
    static var boldFontName                 = "Monda-Bold"
    static var boldFontSize                 = 18
    static var normalFontName               = "Monda-Regular"
    static var normalFontSize               = 18
    static var tableHeaderFontSize          = 15
    static var pickerFontSize               = 14
}

struct admobConfig {
    static var isEnabled = true
    static var adUnitId = "ca-app-pub-6414469769989507/6549753073"
}
