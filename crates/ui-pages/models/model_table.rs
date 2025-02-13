#![allow(non_snake_case)]
use daisy_rsx::*;
use db::Model;
use dioxus::prelude::*;

#[inline_props]
pub fn ModelTable<'a>(cx: Scope, models: &'a Vec<Model>) -> Element {
    cx.render(rsx!(
        Box {
            class: "has-data-table",
            BoxHeader {
                title: "Models"
            }
            BoxBody {
                table {
                    class: "table table-sm",
                    thead {
                        th { "Name" }
                        th { "Base URL" }
                        th { "Model Type" }
                        th { "Parameters" }
                        th { "Context Length" }
                        th {
                            class: "text-right",
                            "Action"
                        }
                    }
                    tbody {

                        models.iter().map(|model| {
                            cx.render(rsx!(
                                tr {
                                    td {
                                        strong {
                                            "{model.name}"
                                        }
                                    }
                                    td {
                                        code {
                                            "{model.base_url}"
                                        }
                                    }
                                    td {
                                        super::model_type::Model {
                                            model_type: model.model_type
                                        }
                                    }
                                    td {
                                        "{model.billion_parameters} Billion"
                                    }
                                    td {
                                        "{model.context_size}"
                                    }
                                    td {
                                        class: "text-right",
                                        DropDown {
                                            direction: Direction::Left,
                                            button_text: "...",
                                            DropDownLink {
                                                href: "#",
                                                drawer_trigger: format!("edit-model-form-{}", model.id),
                                                "Edit"
                                            }
                                        }
                                    }
                                }
                            ))
                        })
                    }
                }
            }
        }
    ))
}
