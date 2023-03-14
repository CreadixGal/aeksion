import { Controller } from "@hotwired/stimulus"
import  Quill  from  "quill"

import * as Emoji from "quill-emoji"

export default class extends Controller {
  static targets = ['content', 'editor']

  toolbarOptions() {
    Quill.register("modules/emoji", Emoji);

    let toolbarOptions = {
      container: [
        ['bold', 'italic', { 'align': [] },{ 'size': [] }, { 'font': [ 'sofia', 'slabo', 'roboto', 'inconsolata', 'ubuntu'] }],
        [{ 'color': [] }, { 'background': [] }],
        [ 'link', 'emoji']
      ], 
      handlers: {
        'emoji': function () {}
      }
    }
    
    return toolbarOptions;
  }

  connect() {
    this.init()
  }

  init(){
    this.quill = new Quill(this.editorTarget, {
      modules: {
        toolbar: this.toolbarOptions(),
        "emoji-toolbar": true,
        "emoji-shortname": true,
      },
      theme: 'snow'
    })
  }

  save(e) {
    this.contentTarget.value = this.quill.root.innerHTML
  }

  addEditor() {
    const newEditorTarget = this.editorTargets[this.editorTargets.length - 1]
    if (newEditorTarget) {
      new Quill(newEditorTarget, {
        modules: {
          toolbar: this.toolbarOptions(),
          "emoji-toolbar": true,
          "emoji-shortname": true,
        },
        theme: 'snow'
      })
    }
  }
}