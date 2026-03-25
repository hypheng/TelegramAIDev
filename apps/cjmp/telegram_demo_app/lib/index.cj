package ohos_app_cangjie_entry

internal import ohos.base.LengthProp
internal import ohos.component.*
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ObservedProperty
internal import ohos.state_manage.LocalStorage
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State

@Entry
@Component
class EntryView {
    @State var screen: String = "bootstrapping"
    @State var phoneDraft: String = ""
    @State var failureMessage: String = ""
    @State var loginNotice: String = ""

    public override func aboutToAppear(): Unit {
        this.bootstrap()
    }

    func bootstrap(): Unit {
        this.screen = "bootstrapping"
        this.failureMessage = ""
        this.loginNotice = ""

        if (!SharedSliceOneAssets.copyIntoFrameworkApp) {
            this.showFailure(SharedSliceOneAssets.bootstrapFailureNotice)
            return
        }
        if (SharedSliceOneAssets.allowDirectRuntimeReadFromSharedSource) {
            this.showFailure(SharedSliceOneAssets.bootstrapFailureNotice)
            return
        }
        if (!SharedSliceOneAssets.hasSliceOneAppMark) {
            this.showFailure(SharedSliceOneAssets.bootstrapFailureNotice)
            return
        }
        if (SharedSliceOneAssets.defaultAuthenticatedDestination == "") {
            this.showFailure(SharedSliceOneAssets.bootstrapFailureNotice)
            return
        }

        this.screen = "login"
    }

    func showFailure(message: String): Unit {
        this.failureMessage = message
        this.screen = "failure"
    }

    func submitLoginHandoff(): Unit {
        AppLog.info("Slice #1 login CTA pressed; authenticated handoff remains out of scope until slice #2.")
        this.loginNotice = "Demo verification and authenticated handoff start in slice #2. This slice keeps the route boundary at login only."
    }

    func build() {
        Column() {
            if (this.screen == "bootstrapping") {
                Column() {
                    Column() {
                        Text("TG")
                            .width(64)
                            .height(64)
                            .fontSize(SharedSliceOneAssets.titleFontSize)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(SharedSliceOneAssets.inverseTextColor)
                            .textAlign(TextAlign.Center)
                            .backgroundColor(SharedSliceOneAssets.brandColor)
                            .borderRadius(32)

                        Text(SharedSliceOneAssets.bootstrapTitle)
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.titleFontSize)
                            .fontWeight(FontWeight.Medium)
                            .fontColor(SharedSliceOneAssets.primaryTextColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingLg)

                        Text(SharedSliceOneAssets.bootstrapBody)
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.bodyFontSize)
                            .fontColor(SharedSliceOneAssets.secondaryTextColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingMd)

                        Text("•••")
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.iconXl)
                            .fontColor(SharedSliceOneAssets.brandColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingLg)
                    }
                    .width(100.percent)
                    .padding(SharedSliceOneAssets.spacingXxl)
                    .backgroundColor(SharedSliceOneAssets.screenSurfaceColor)
                    .borderRadius(SharedSliceOneAssets.radiusCard)
                }
                .width(100.percent)
                .padding(left: SharedSliceOneAssets.spacingXl, right: SharedSliceOneAssets.spacingXl, top: 96, bottom: SharedSliceOneAssets.spacingXl)
            } else if (this.screen == "failure") {
                Column() {
                    Column() {
                        Text("TG")
                            .width(64)
                            .height(64)
                            .fontSize(SharedSliceOneAssets.titleFontSize)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(SharedSliceOneAssets.inverseTextColor)
                            .textAlign(TextAlign.Center)
                            .backgroundColor(SharedSliceOneAssets.brandColor)
                            .borderRadius(32)

                        Text(SharedSliceOneAssets.bootstrapTitle)
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.titleFontSize)
                            .fontWeight(FontWeight.Medium)
                            .fontColor(SharedSliceOneAssets.primaryTextColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingLg)

                        Text(if (this.failureMessage == "") { SharedSliceOneAssets.bootstrapFailureNotice } else { this.failureMessage })
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.bodyFontSize)
                            .fontColor(SharedSliceOneAssets.errorColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingMd)

                        Text(SharedSliceOneAssets.appMarkSource)
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.captionFontSize)
                            .fontColor(SharedSliceOneAssets.mutedTextColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingLg)

                        Button("Retry startup")
                            .width(100.percent)
                            .height(48)
                            .margin(top: SharedSliceOneAssets.spacingLg)
                            .backgroundColor(SharedSliceOneAssets.brandSoftColor)
                            .fontColor(SharedSliceOneAssets.brandStrongColor)
                            .onClick({ _ =>
                                this.bootstrap()
                            })
                    }
                    .width(100.percent)
                    .padding(SharedSliceOneAssets.spacingXxl)
                    .backgroundColor(SharedSliceOneAssets.screenSurfaceColor)
                    .borderRadius(SharedSliceOneAssets.radiusCard)
                }
                .width(100.percent)
                .padding(left: SharedSliceOneAssets.spacingXl, right: SharedSliceOneAssets.spacingXl, top: 96, bottom: SharedSliceOneAssets.spacingXl)
            } else if (this.screen == SharedSliceOneAssets.defaultAuthenticatedDestination) {
                Column() {
                    Column() {
                        Text("TG")
                            .width(64)
                            .height(64)
                            .fontSize(SharedSliceOneAssets.titleFontSize)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(SharedSliceOneAssets.inverseTextColor)
                            .textAlign(TextAlign.Center)
                            .backgroundColor(SharedSliceOneAssets.brandColor)
                            .borderRadius(32)

                        Text(SharedSliceOneAssets.loginBrandTitle)
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.titleFontSize)
                            .fontWeight(FontWeight.Medium)
                            .fontColor(SharedSliceOneAssets.primaryTextColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingLg)

                        Text(SharedSliceOneAssets.placeholderNotice)
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.bodyStrongFontSize)
                            .fontColor(SharedSliceOneAssets.primaryTextColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingMd)
                    }
                    .width(100.percent)
                    .padding(SharedSliceOneAssets.spacingXxl)
                    .backgroundColor(SharedSliceOneAssets.screenSurfaceColor)
                    .borderRadius(SharedSliceOneAssets.radiusCard)
                }
                .width(100.percent)
                .padding(left: SharedSliceOneAssets.spacingXl, right: SharedSliceOneAssets.spacingXl, top: 96, bottom: SharedSliceOneAssets.spacingXl)
            } else {
                Column() {
                    Column() {
                        Text("TG")
                            .width(64)
                            .height(64)
                            .fontSize(SharedSliceOneAssets.titleFontSize)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(SharedSliceOneAssets.inverseTextColor)
                            .textAlign(TextAlign.Center)
                            .backgroundColor(SharedSliceOneAssets.brandColor)
                            .borderRadius(32)

                        Text(SharedSliceOneAssets.loginBrandTitle)
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.headlineFontSize)
                            .fontWeight(FontWeight.Medium)
                            .fontColor(SharedSliceOneAssets.primaryTextColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingLg)

                        Text(SharedSliceOneAssets.loginHeadline)
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.titleFontSize)
                            .fontWeight(FontWeight.Medium)
                            .fontColor(SharedSliceOneAssets.primaryTextColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingSm)

                        Text(SharedSliceOneAssets.loginBody)
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.bodyFontSize)
                            .fontColor(SharedSliceOneAssets.secondaryTextColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingMd)

                        Text(SharedSliceOneAssets.loginPhoneLabel)
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.captionFontSize)
                            .fontColor(SharedSliceOneAssets.secondaryTextColor)
                            .margin(top: SharedSliceOneAssets.spacingXl, bottom: SharedSliceOneAssets.spacingSm)

                        TextInput(text: this.phoneDraft, placeholder: SharedSliceOneAssets.loginPhoneHint)
                            .height(52)
                            .padding(left: SharedSliceOneAssets.spacingLg, right: SharedSliceOneAssets.spacingLg)
                            .backgroundColor(SharedSliceOneAssets.subtleSurfaceColor)
                            .borderRadius(SharedSliceOneAssets.radiusField)
                            .maxLength(20)
                            .onChange({ value: String =>
                                this.phoneDraft = value
                            })

                        Button(SharedSliceOneAssets.loginContinueLabel)
                            .width(100.percent)
                            .height(52)
                            .margin(top: SharedSliceOneAssets.spacingLg)
                            .backgroundColor(SharedSliceOneAssets.brandColor)
                            .fontColor(SharedSliceOneAssets.inverseTextColor)
                            .onClick({ _ =>
                                this.submitLoginHandoff()
                            })

                        if (this.loginNotice != "") {
                            Text(this.loginNotice)
                                .width(100.percent)
                                .fontSize(SharedSliceOneAssets.bodyFontSize)
                                .fontColor(SharedSliceOneAssets.secondaryTextColor)
                                .textAlign(TextAlign.Center)
                                .margin(top: SharedSliceOneAssets.spacingLg)
                        }

                        Text(SharedSliceOneAssets.loginFooter)
                            .width(100.percent)
                            .fontSize(SharedSliceOneAssets.captionFontSize)
                            .fontColor(SharedSliceOneAssets.mutedTextColor)
                            .textAlign(TextAlign.Center)
                            .margin(top: SharedSliceOneAssets.spacingLg)
                    }
                    .width(100.percent)
                    .padding(SharedSliceOneAssets.spacingXxl)
                    .backgroundColor(SharedSliceOneAssets.screenSurfaceColor)
                    .borderRadius(SharedSliceOneAssets.radiusCard)
                }
                .width(100.percent)
                .padding(left: SharedSliceOneAssets.spacingXl, right: SharedSliceOneAssets.spacingXl, top: 56, bottom: SharedSliceOneAssets.spacingXl)
            }
        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(SharedSliceOneAssets.appBackgroundColor)
    }
}
